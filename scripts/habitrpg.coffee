# Description:
#   Habit RPG Status & Updates for Hubot
#
# Commands:
#   habit status - Checks status of habit rpg

module.exports = (robot) ->
  robot.respond /habit status/i, (msg) ->
    msg.send "Checking status of the HabitRPG API..."
    robot.http('http://habitrpg.com/api/v1/status?x-api-user=0462dac4-c421-4b1b-9637-dd64e4ee32b6&x-api-key=e9ba72bf-32a3-4dfd-a064-68ec8cbf5c31')
      .get() (err, res, body) ->
        msg.send JSON.parse(body)