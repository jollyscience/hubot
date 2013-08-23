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

  robot.respond /make me laugh/i, (msg) ->
  	msg.send "Knock knock"
  	msg.waitResponse (robot) ->
  		answer = "who\'s there?"
  		if robot.match[1] != answer
	  		msg.send "Awe... You are supposed to say \"#{answer}\""
	  	else
	  		msg.send "Banana"
		  	msg.waitResponse (robot) ->
		  		answer = "banana who?"
		  		if robot.match[1] != answer
		  			msg.send "Dude. Have you really never seen how this is done?"
		  		else
		  			msg.send "Yay. You made it to the end. Now there are exactly ZERO more knock knock jokes in the world."