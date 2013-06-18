# Description:
#   Habit RPG
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   habit status - Checks status of habit rpg

module.exports = (robot) ->

  robot.respond /habit status/i, (msg) ->
    robot.http("https://habitrpg.com/api/v1/status")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).status