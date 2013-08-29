# Description:
#   Codebase Stuff
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:

Codebase = require('node-codebase')

module.exports = (robot) ->
	
	robot.respond /cb ping/, (msg) ->
		msg.send "PONG"