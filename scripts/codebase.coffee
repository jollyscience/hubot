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
#   codebase activity
#   codebase projects

Codebase = require('node-codebase')

url = process.env.HUBOT_CODEBASE_URL || 'api3.codebasehq.com'
auth = process.env.HUBOT_CODEBASE_AUTH || 'jollyscience/jollyscience:3kqo5bdat3uln2bnv90mvvti1stuonjg99bnz1p4'

cb = new Codebase(
	url, auth
)

module.exports = (robot) ->

# ROBOT RESPONDERS
	robot.respond /report codebase activity/i, (msg) ->
		msg.send 'checking for codebase activity...'

		cb.activity( (err, data) ->
			if (err)
				msg.send('There was an error!' + data)

			for item in data.events.event then do (item) =>
				msg.send item.title
		)

	robot.respond /report codebase projects/i, (msg) ->
		msg.send 'checking for codebase projects...'

		cb.projects.all( (err, data) ->
			if (err)
				msg.send('There was an error!' + data)

			r = []
			msg.send "The Codebase projects I know about are as follows...\n"
			for item in data.projects.project then do (item) =>
				r.push "(#{count}) #{item.name} (#{item.permalink})"

			msg.send r.join()
			msg.send "That is all of them. " + count + " in all."
		)

	robot.respond /create codebase project (.*)/i, (msg) ->
		msg.send 'oiling my tools for work...'
		msg.send 'connecting to codebase...'

		cb.projects.create( msg.match[1], (err, data) ->

			msg.send 'navigating the matrix...'

			if (err)
				msg.send('CRAP! There was an error!' + data)

			project = data.project
			msg.send "Project Created!\n#{project.name} - #{project.permalink}"
		)

	robot.respond /delete codebase project (.*)/i, (msg) ->


		cb.projects.deleteProject( msg.match[1], (err, data) ->

			msg.send 'I hope you know what you are doing...'

			if (err)
				msg.send ('Awe man... I messed up...' + data)

			msg.send JSON.stringify(data)
		)