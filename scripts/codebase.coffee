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

# Codebase = require('node-codebase')

module.exports = (robot) ->
  baseurl = 'jollyscience.codebasehq.com'

  robot.respond /codebase activity/i, (msg) ->

    robot.http( "https://#{baseurl}/activity" )

      .headers
        'username': 'jollyscience/jollyscience:3kqo5bdat3uln2bnv90mvvti1stuonjg99bnz1p4',
#        'Authentication': 'Basic'

      .get() (err, res, body) ->
        msg.send JSON.parse(body)