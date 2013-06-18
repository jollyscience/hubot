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
#   None
#

Codebase = require('node-codebase')
cb = new Codebase(
	'http://api3.codebasehq.com',
    'jollyscience/jollyscience:3kqo5bdat3uln2bnv90mvvti1stuonjg99bnz1p4'
)

module.exports = (robot) ->

  robot.respond /codebase activity/i, (msg) ->
  	console.log ( 'Checking codebase activity...' )

  	ret = (err, data) ->
      msg.send( JSON.stringify( data ) )
    cb.activity( ret );