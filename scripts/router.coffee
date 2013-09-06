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
  robot.router.get '/josi/harvest/project/new', (req, res) ->
    room = "180403"
    data = JSON.parse req.body.payload
    robot.messageRoom "New Harvest Project! #{data}"
    res.send "Thanks!"
    res.send data