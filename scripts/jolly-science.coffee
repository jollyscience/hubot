# Description:
#   Jollyscience Project Creation
#
# Dependencies:
#   mkdirp, mustache, randpass
#
# Configuration:
#   JS_WWW_DIR
#   JS_DEV_URL
#   JS_STAGE_URL
#   JS_MYSQL_USER
#   JS_MYSQL_PASSWORD
#
# Commands:
#   hubot create (empty|concrete) project <client_code> <project_code> - Creates an empty/Concrete5 project on the server. `client_code` and `project_code` should be between 3 and 7 characters, and contain only letters, numbers, dashes (-) and underscores (_)
#   hubot (update|set) project repo <client_code> <project_code> <repo_url> - Sets the project repository, and pushes the current data to that repo
#
# Todo:
#   Test Install
#   Resume?
#   Check for existing site
#   
#
# Author:
#   Sam Bernard
#mustache = require("mustache")

module.exports = (robot) ->

  mysql_user = process.env.JS_MYSQL_USER || "root"
  mysql_pass = process.env.JS_MYSQL_PASSWORD || "root"
  www_dir = process.env.JS_WWW_DIR || "/var/www/site/"
  dev_url = process.env.JS_DEV_URL || "dev.jollyscience.info"
  stage_url = process.env.JS_STAGE_URL || "stage.jollyscience.info"

  class JollyScience
    config: 
      sites:
        directory: www_dir
        dev: dev_url
        stage: stage_url
      mysql:
        rootUser: mysql_user
        rootPassword: mysql_pass
      types:
        concrete:
          gitPath: 'git@codebasehq.com:jollyscience/internal/concrete-skeleton.git'
          dump: 'sql/dump.sql'
          mysqlConfig: 'docroot/config/site.php'
        empty:
          gitPath: 'git@codebasehq.com:jollyscience/internal/empty-skeleton.git'
          dump: null
          mysqlConfig: 'resources/mysql.mdown'

    project:
      client_code: ''
      project_code: ''
      db_user: ''
      db_name: ''
      url: ''
      path: ''
      type: ''
      repo_url: ''
  
    init: (robot, msg, client, project, type) ->
      @robot = robot
      @msg = msg
      @project.client_code = client
      @project.project_code = project
      @project.type = type      
      @project.url = "#{client}-#{project}.#{@config.sites.dev}"
      @project.path = "#{@config.sites.directory}/#{@project.url}"
    
    loadData: (data) =>
      @project = data
    
    create: =>
      @createDevDirectory()  
    
    createDevDirectory: =>      
      mkdirp = require("mkdirp")
      mkdirp @project.path, (err) =>
        unless err
          @msg.send "#{@project.path} created!"
          @cloneSkeleton()
        else
          @msg.send "Error creating #{@project.path}, #{err}"      
    
    cloneSkeleton: () ->
      sys = require 'sys'
      exec = require('child_process').exec
      
      @msg.send "Cloning Git Repo (this may take awhile)"
      
      gitPath = @config.types[@project.type].gitPath
      
      command = "git clone #{gitPath} #{@project.path}"
      
      exec command, (err, stdout, stderror) =>
        unless err?
          @msg.send "#{@project.type} skeleton repository cloned"
          @createDatabase()          
        else
          @msg.send "There was an error cloning the #{@project.type} skeleton repository: #{err}"    
          @msg.send command
    
    createDatabase: () =>
      exec = require('child_process').exec
      randpass = require('randpass')
      
      @project.db_name = "#{@project.client_code}_#{@project.project_code}"
      @project.db_name = @project.db_name.replace(/[^a-zA-Z0-9_]/g, '_')
      @project.db_user = @project.db_name
      @dbPassword = randpass(10)
      
      @createConfigFiles()
      
      mysqlCommand = 
      "CREATE DATABASE #{@project.db_name};
      GRANT ALL PRIVILEGES ON #{@project.db_name}.* TO #{@project.db_user}@localhost IDENTIFIED BY \"#{@dbPassword}\";"
      
      command = "mysql -u #{@config.mysql.rootUser} -p'#{@config.mysql.rootPassword}' -e '#{mysqlCommand}'"
      
      exec command, (err, stdout, stderror) =>
        unless err?
          @msg.send "Database and user created!"
          
          if @config.types[@project.type].dump?          
            @msg.send "Installing the database dump (this may take awhile)"
                    
            command = "mysql -u #{@config.mysql.rootUser} -p'#{@config.mysql.rootPassword}' #{@project.db_name} < #{@project.path}/sql/dump.sql"
            
            exec command, (err, stdout, stderror) =>
              unless err?
                @msg.send "Database dump loaded!"
                @finished()
              else
                @msg.send "Error creating database: #{err}"
                @msg.send "#{stdout}"
                @msg.send "#{stderror}"
                @msg.send command
          else
            @finished()
        else
          @msg.send "Error creating database: #{err}"    
    
    createConfigFiles: () =>
      fs = require('fs');
      configFile = @config.types[@project.type].mysqlConfig
      output =  "#{@project.path}/#{configFile}"
      template = "#{output}.scaffold"
      
      @msg.send template
      
      fs.readFile template, 'utf8', (err, data) =>
        unless err?
          Mustache = require 'mustache' 
          
          template = data
          view = 
            db:
              host: 'localhost'
              user: @project.db_user
              password: @dbPassword
              database: @project.db_name
          
          rendered = Mustache.render template, view
          
          fs.writeFile output, rendered, (err) =>
            unless err
              @msg.send 'Config file saved'
            else
              @msg.send "Config file could not be saved: #{err}"            
          
        else
          @msg.send "Error reading config template"
    
    loadProjectData: =>
    
    
    finished: =>
      @msg.send "Site created! You can access it at http://#{@project.url}"
      
      if @project.type is 'concrete'
        @msg.send "You can login at http://#{@project.url}/dashboard. The admin username is `admin` and the password is `ChangeMe!`. Please make sure to change the administrator password."
      else
        @msg.send "The mysql configuration information can be found in #{@project.path}/#{@config.types[@project.type].mysqlConfig}"
      
      projects = @robot.brain.get('generated_projects') or {}
      
      unless projects[@project.client_code]? then projects[@project.client_code] = {}
      
      projects[@project.client_code][@project.project_code] = @project 
      
      @robot.brain.set 'generated_projects', projects
      
    setProjectRepo: (url) =>
      exec = require('child_process').exec
      
      command = "cd #{@project.path} && git remote set-url origin #{url} && git push origin --mirror"
      
      exec command, (err, stdout, stderror) =>
        unless err?
          @msg.send 'All data has been pushed to new origin'          
        else
          @msg.send "There was an error updating the git repository origin: #{err}" 
          @msg.send stdout
          @msg.send stderror
          @msg.send command


  robot.respond /create (empty|concrete) project ([a-z_0-9-]{3,7}) ([a-z_0-9-]{3,8})/i, (msg) ->    
    type = msg.match[1]
    client = msg.match[2]
    project = msg.match[3]
    
    projects = robot.brain.get('generated_projects') or null

    unless projects? and projects[client]? and projects[client][project]?    
      msg.send "Creating Project…"
      js = new JollyScience
      js.init robot, msg, client, project, type
      
      js.create()
    else
      current_project = projects[client][project]
      msg.send "This project already exists. If you had errors creating it, you can manually delete the project folder `#{current_project.path}`, and the project database `#{current_project.db_name}`."
    
  robot.respond /(update|set) project repo(sitory)? ([a-z_0-9-]+) ([a-z_0-9-]+) ([^\s]+)/i, (msg) ->
    client = msg.match[3]
    project = msg.match[4]
    repoURL = msg.match[5]
    
    projects = robot.brain.get('generated_projects') or null
    
    if projects?
      if projects[client]? and projects[client][project]?
        current_project = projects[client][project]
          
        js = new JollyScience
        js.robot = robot
        js.msg = msg
        js.loadData(current_project)
        js.setProjectRepo repoURL
        
      else
        msg.send "I don't know about this project. Perhaps you should create it?"
    else
      msg.send "I don't know about this project. Perhaps you should create it?"

#   robot.respond /(delete|remove) project ([a-z_0-9-]+) ([a-z_0-9-]+)/i, (msg) ->
#     client = msg.match[2]
#     project = msg.match[3]
#     
#     projects = robot.brain.get('generated_projects') or null
#     
#     if projects?
#       if projects[client]? and projects[client][project]?
#         current_project = projects[client][project]
#           
#         js = new JollyScience
#         js.robot = robot
#         js.msg = msg
#         js.loadData(current_project)
#         js.delete()
#         
#       else
#         msg.send "I don't know about this project. Perhaps it doesn't exist?"
#     else
#       msg.send "I don't know about this project. Perhaps it doesn't exist?"
  
  robot.respond /(show|debug) project data/i, (msg) ->  
    Util = require "util"
    
#     projects = robot.brain.get('generated_projects') or null
    output = Util.inspect(msg.message.user.id, false, 4)
    msg.send output