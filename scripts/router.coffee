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
  robot.router.get '/chat/:room', (req, res) ->
  	
    # room = req.params.room
    # data = JSON.parse req.body.payload
    # secret = data.secret

    # robot.messageRoom "I have a secret: #{secret}"