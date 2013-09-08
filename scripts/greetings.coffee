# Description:
#
# Commands:
#
# Events:
#   

enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']

module.exports = (robot) ->
  robot.enter (msg) ->
    msg.send msg.random enterReplies