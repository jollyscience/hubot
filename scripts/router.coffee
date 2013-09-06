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
  robot.router.post '/josi/harvest/project/new', (req, res) ->
    room = "180403"
    data = JSON.parse req.body.payload
    robot.messageRoom room, "New Harvest Project! #{data}"
    res.end