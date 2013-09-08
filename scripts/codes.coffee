# Description:
#   Event system related utilities
#
# Commands:
#   hubot code <color> say <message> - Write emergency messages in color
#
# Events:
#   

module.exports = (robot) ->

  robot.respond /code (red|yellow|green|gray|purple|random) say (.+?)$/i, (msg) ->
    url = "http://jollyscience.info:5555/hubot/hipchat?room_id=#{msg.message.room}&from=#{msg.message.user.name}&message=#{msg.match[2]}&color=#{msg.match[1]}&message_format=html"
    msg.get(url) (err, res, body) ->
        if err
            msg.send "There was an error: #{err}"
        else
            msg.send JSON.parse(body).status