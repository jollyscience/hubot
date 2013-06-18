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
#   hubot <keyword> tweet - Returns a link to a tweet about <keyword>
#
# Todo:
#   Create Vhost
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
      concrete:
        gitPath: 'git@codebasehq.com:jollyscience/internal/concrete-skeleton.git'
        dump: 'sql/dump.sql'
        config: 'docroot/config/site.php'
      mysql:
        rootUser: mysql_user
        rootPassword: mysql_pass
        #'j0lly5Ci!'
#         rootPassword: 'root'
  
    init: (msg, client, project) ->
      @msg = msg
      @client = client
      @project = project
      @devURL = "#{client}-#{project}.#{@config.sites.dev}"
      @devPath = "#{@config.sites.directory}/#{@devURL}"
      @msg.send "Initializing Project. Client Code: #{client} -- Project Code: #{project}"

    createDevDirectory: =>      
      mkdirp = require("mkdirp")

      mkdirp "#{@devPath}", (err) =>
        unless err
          @msg.send "#{@devPath} created!"
          @cloneConcreteFiles()
        else
          @msg.send "Error creating #{@devPath}, #{err}"      
    
    cloneConcreteFiles: () ->
      sys = require 'sys'
      exec = require('child_process').exec
      
      @msg.send "Cloning Git Repo (this may take awhile)"
      
      command = "git clone #{@config.concrete.gitPath} #{@devPath}"
      
      exec command, (err, stdout, stderror) =>
        unless err?
          @msg.send 'Concrete5 Directory Cloned'
          @createDatabase()          
        else
          @msg.send "There was an error cloning the concrete5 repository: #{err}"    
          @msg.send command
    
    createConfigFiles: () =>
      fs = require('fs');
      output =  "#{@devPath}/#{@config.concrete.config}"
      template = "#{output}.scaffold"
      
      fs.readFile template, 'utf8', (err, data) =>
        unless err?
          Mustache = require 'mustache' 
          
          template = data
          view = 
            db:
              host: 'localhost'
              user: @dbUser
              password: @dbPassword
              database: @dbName
          
          rendered = Mustache.render template, view
          
          fs.writeFile output, rendered, (err) =>
            unless err
              @msg.send 'Config file saved'
            else
              @msg.send "Config file could not be saved: #{err}"            
          
        else
          @msg.send "Error reading config template"
    
    createDatabase: () =>
      exec = require('child_process').exec
      randpass = require('randpass')
      
      @dbName = "#{@client}_#{@project}"
      @dbName = @dbName.replace(/[^a-zA-Z0-9_]/, '_')
      @dbUser = @dbName
      @dbPassword = randpass(10)
      
      @createConfigFiles()
      
      mysqlCommand = 
      "CREATE DATABASE IF NOT EXISTS #{@dbName};
      GRANT ALL PRIVILEGES ON #{@dbName}.* TO #{@dbUser}@localhost IDENTIFIED BY \"#{@dbPassword}\";"
      
      command = "mysql -u #{@config.mysql.rootUser} -p'#{@config.mysql.rootPassword}' -e '#{mysqlCommand}'"
      
      exec command, (err, stdout, stderror) =>
        unless err?
          @msg.send "Database and user created!"
          @msg.send "Installing the database dump (this may take awhile)"
                  
          command = "mysql -u #{@config.mysql.rootUser} -p'#{@config.mysql.rootPassword}' #{@dbName} < #{@devPath}/sql/dump.sql"
          
          exec command, (err, stdout, stderror) =>
            unless err?
              @msg.send "Database dump loaded!"
              @finishedMessage()
            else
              @msg.send "Error creating database: #{err}"
              @msg.send "#{stdout}"
              @msg.send "#{stderror}"
              @msg.send command
        else
          @msg.send "Error creating database: #{err}"
    
    finishedMessage: =>
      @msg.send "Site created! You can access it at http://#{@devURL}"
      @msg.send "You can login at http://#{@devURL}/dashboard. The admin username is `admin` and the password is `ChangeMe!`. Please make sure to change the administrator password."

    setProjectRepo: (url) =>
      exec = require('child_process').exec
      
      command = "cd #{@devPath} && git remote set-url origin #{url} && git push origin --mirror"
      
      exec command, (err, stdout, stderror) =>
        unless err?
          @msg.send 'All data has been pushed to new origin'          
        else
          @msg.send "There was an error updating the git repository origin: #{err}" 
          @msg.send stdout
          @msg.send stderror
          @msg.send command

  robot.respond /create concrete5 project ([a-z_0-9-]+) ([a-z_0-9-]+)/i, (msg) ->    
    client = msg.match[1]
    project = msg.match[2]
    
    js = new JollyScience
    js.init msg, client, project
    
    js.createDevDirectory()
    
  robot.respond /(update|set) project repo(sitory)? ([a-z_0-9-]+) ([a-z_0-9-]+) ([^\s]+)/i, (msg) ->
    client = msg.match[3]
    project = msg.match[4]
    repoURL = msg.match[5]
    
    js = new JollyScience
    js.init msg, client, project
    
    js.setProjectRepo repoURL    
