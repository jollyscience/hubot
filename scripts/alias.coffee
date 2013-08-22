# Description:
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   hubot <user> has <role> role - Assigns a role to a user
#
# Notes:
#
# Author:
#   meshachjackson
# 
# TODO: Rewrite this to manage users' identity in the robot brain, and allow users to provide **contextual aliases**

TextMessage = require('hubot').TextMessage

module.exports = (robot) ->

  robot.respond /i am ([a-z0-9-]+) on ([a-z0-9-]+)/i, (msg) ->
    alias = msg.match[1]
    context = msg.match[2]
    user = robot.brain.userForName(msg.message.user.name)
    user.aliases = user.aliases or {}
    user.aliases[context] = alias
    userStr = JSON.stringify(user.aliases)
    msg.send "You are now known as: #{userStr}"

  robot.respond /show aliases/i, (msg) ->
    theReply = [ ]
    theReply.push("Here are the aliases I know:")
    for own key, user of robot.brain.users()
      if(user.aliases)
        alist = [ ]
        for own context, alias of user.aliases
          alist.push("\'#{alias}\' on #{context}")
        astr = alist.join(', and by ')
        theReply.push("- #{user.name} goes by #{astr}")
    msg.send theReply.join('\n') + "."

  robot.respond /clear aliases/i, (msg) ->
    for own key, user of robot.brain.users()
      user.aliases = {}
    msg.send "Hope you knew what you were doing!"
    msg.message.text = "hubot show aliases"
    msg.robot.receive msg.message