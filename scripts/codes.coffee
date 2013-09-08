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
    url = "http://jollyscience.info:5555/hubot/hipchat?room_id=#{msg.message.room}&from=#{msg.message.user.name}&message=#{msg.match[2]}&color=#{msg.match[1]}"
    msg.http(url)
    .query()
    .get() (err, res, body) ->
        if err
            msg.send "There was an error: #{err}"
        else
            msg.send JSON.parse(body).status