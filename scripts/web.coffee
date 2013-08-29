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
  	msg.waitResponse (msg) ->
  		answer = "who\'s there?"
  		if msg.match[1] != answer
	  		msg.send "Awe... You are supposed to say \"#{answer}\""
	  	else
	  		msg.send "Banana"
		  	msg.waitResponse (msg) ->
		  		answer = "banana who?"
		  		if msg.match[1] != answer
		  			msg.send "Dude. Have you really never seen how this is done?"
		  		else
		  			msg.message.text = "#{robot.name} animate me banana"
		  			robot.receive msg.message