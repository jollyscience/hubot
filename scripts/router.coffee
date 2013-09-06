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
    
    msg = JSON.stringify data

    robot.messageRoom room, "New Harvest Project! #{msg}"

	res.writeHead 204, { 'Content-Length': 0 }
    res.end()