# Description:
#
# Commands:
#
# Events:
#   

enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you', 'Are we playing hide and seek?']

module.exports = (robot) ->

  robot.enter (msg) ->
    msg.send msg.random enterReplies