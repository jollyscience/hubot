# Description:
#   Event system related utilities
#
# Commands:
#   hubot code <color> say <message> - Write emergency messages in color
#
# Events:
#   

module.exports = (robot) ->

  robot.respond /code (red|blue|green|yellow) say (.+?)$/i, (msg) ->
  	color = msg.match[1]
  	text = msg.match[2]

	q = {
		room_id: msg.message.room,
		message: text,
		from: msg.message.user.name,
		color: color
	}

  	msg.http('http://jollyscience.info:5555/hubot/hipchat')
    .query(q)
    .get() (err, res, body) ->
    	if err
    		msg.send "There was an error: #{err}"
    	else
		  	msg.send JSON.parse(body).status