# Description
#   Send all uncaught commands to cleverbot.
#   Based on:
#   https://github.com/github/hubot-scripts/blob/master/src/scripts/cleverbot.coffee
#
# Dependencies:
#   "cleverbot-node": "0.1.1"
#
# Commands:
#   hubot (.*) - If not caught by another script, replies with cleverbot response.
#
# Author:
#   EvanDotPro

cleverbot = require('cleverbot-node')

class Clever
    wasters: {
        "hm...",
        "well",
        "interesting..."
    }

    constructor: (@robot) ->
        @bot_sessions = {}

    speak: (msg) ->
        msg.send msg.random @wasters

        sessionKey = msg.message.room or msg.message.user.name or "olly"

        if not @bot_sessions[sessionKey]?
            @bot_sessions[sessionKey] = new cleverbot()

        c = @bot_sessions[sessionKey]
        console.log c

        replace = new RegExp "^(@?" + msg.robot.name + "[:,]?)", "i"
        data = msg.message.text.trim().replace(replace, '').trim()
        console.log '« CLEVERBOT ('+sessionKey+'): ' + data
        c.write data, (c) =>
            response = c.message.replace /cleverbot/i, msg.robot.name
            console.log '» CLEVERBOT ('+sessionKey+'): ' + response
            msg.send response

module.exports = (robot) ->
  robot.clever = new Clever robot

  robot.catchAll (msg) ->
    if (robot.name != msg.message.user.name && !(new RegExp("^#{robot.name}", "i").test(msg.match)))
        robot.clever.speak msg

  robot.hear /clever/, (msg) ->
    robot.clever.speak msg