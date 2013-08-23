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

  robot.respond /knock knock/i, (msg) ->
  	msg.topic "Joke Time!"
  	msg.send "Who is there?"
  	msg.waitResponse (msg) ->
  		msg.send "huh?"