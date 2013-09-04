# Description:
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#
# Notes:
#
# Author:
#   meshachjackson

module.exports = (robot) ->
  robot.router.get '/hubot/ping', (req, res) ->
    res.send('pong')

  robot.respond /when i say \s*(.*)?$ you say (.+)/i, (msg) ->
  	call = msg.match[1]
  	command = msg.match[2]

  	msg.send "Okay. When you say #{call} I will say #{command}"