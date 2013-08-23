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

  robot.respond /set topic to ([a-z 0-9-_]+)/i, (msg) ->
  	msg.topic "sometopic"
  	msg.send "topic!"
