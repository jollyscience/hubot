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
  	msg.send "who is there?"
	robot.waitResponse (msg) -> 
		console.log msg