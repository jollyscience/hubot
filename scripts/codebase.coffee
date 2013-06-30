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
# report codebase users
# report codebase activity
# report codebase projects
# report codebase project <permalink>
# create codebase project <Full Project Name>
# delete codebase project <permalink>
# create codebase ticket in project <permalink> with summary <summary>
# report codebase updates to ticket <ticket_id> in project <permalink>


Codebase = require('node-codebase')
_ = require('underscore')

module.exports = (robot) ->

	baseUrl = process.env.HUBOT_CODEBASE_BASEURL || "jollyscience.codebasehq.com"
	apiUrl = process.env.HUBOT_CODEBASE_APIURL || 'api3.codebasehq.com'
	auth = process.env.HUBOT_CODEBASE_APIAUTH || 'jollyscience/jollyscience:3kqo5bdat3uln2bnv90mvvti1stuonjg99bnz1p4'

	cb = new Codebase(
		apiUrl, auth
	)

# ROBOT RESPONDERS

# REPORT USERS
	robot.respond /report codebase users/i, (msg) ->
		msg.send "Okay. I\'ll go get a list of all Codebase users..."

		cb.users.all( (err, data) ->
			if (err)
				msg.send "Oh no! #{data}"

			else
				r = []
				ul = data.users.user
				for user in ul then do (user) =>
					if _.isObject(user.company[0])
						co = "Freelance"
					else
						co = user.company.join(', ')

					r.push "#{user.firstName} #{user.lastName} (#{co})"

				msg.send r.join(', ')
		)

# REPORT ALL ACTIVITY
	robot.respond /report codebase activity/i, (msg) ->
		msg.send 'Okay. I\'m checking for codebase activity...'

		cb.activity( (err, data) ->
			if (err)
				msg.send "Oh no! #{data}"

			for item in data.events.event then do (item) =>
				msg.send item.title
		)

# REPORT SINGLE PROJECT
	robot.respond /report codebase project (.*)/i, (msg) ->
		msg.send 'Okay. I am searching the haystack for ' + msg.match[1]

		cb.projects.specific( msg.match[1], (err, data) ->
			if (err)
				msg.send "Oh no! #{data}"

			p = data.project
			msg.send "#{p.name} is an #{p.status} project in the #{p.groupId} group, and is described as #{p.overview}."
			msg.send "You can visit the project on Codebase here: http://#{baseUrl}/projects/#{p.permalink}"
		)

# REPORT ALL PROJECTS
	robot.respond /report codebase projects/i, (msg) ->
		msg.send 'Okay. I am checking for codebase projects...'

		cb.projects.all( (err, data) ->
			if (err)
				msg.send "Oh no! #{data}"

			r = ["The Codebase projects I know about are as follows:"]
			for item in data.projects.project then do (item) =>
				r.push "#{item.name} (#{item.permalink})"

			msg.send r.join(' | ')
			msg.send "That is all of them. #{r.length} total."
		)

# CREATE PROJECT
	robot.respond /create codebase project (.*)/i, (msg) ->
		msg.send 'Alright... I am oiling my tools for work...'
		msg.send 'connecting to codebase...'

		cb.projects.create( msg.match[1], (err, data) ->

			msg.send 'navigating the matrix...'

			if (err)
				msg.send "Oh no! #{data}"

			else
				project = data.project
				msg.send "Project Created!\n#{project.name} - #{project.permalink}"
		)

# DELETE PROJECT
	robot.respond /delete codebase project (.*)/i, (msg) ->
		cb.projects.deleteProject( msg.match[1], (err, data) ->

			msg.send 'I am not allowed do that right now. It is just too unsafe.'

			# if (err)
			# 	e = JSON.stringify(data.data)
			# 	msg.send ("Awe man... I messed up... #{e}")

			# msg.send JSON.stringify(data)
		)

# GET TICKET UPDATES
	robot.respond /report codebase updates to ticket ([0-9]+) in project ([a-z_0-9-]+)/i, (msg) ->
		t = msg.match[1]
		p = msg.match[2]

		msg.send "Okay. I\'ll try to find ticket #{t} in #{p}"

		cb.tickets.notes.all( p, t, (err, data) ->
			if (err)
				msg.send "Oh no! #{data}"

			else
				r = []
				l = data.ticketNotes.ticketNote.length - 1
				msg.send "Ticket #{t} has been updated #{l} times."
		
				for note in data.ticketNotes.ticketNote then do (note) =>
					r.push "#{note.updates}"

				msg.send r.join()
		)

# CREATE TICKET
	robot.respond /create codebase ticket in project ([a-z_0-9-]+) with summary (.*)/i, (msg) ->
		p = msg.match[1]
		s = msg.match[2]

		msg.send "Okay. I\'ll try to create a new ticket in #{p} with a summary of \"#{s}\""
		
		cb.tickets.create( p, { summary: s, description: 'DUMMY Description'}, (err, data) ->
			if (err)
				msg.send "Oh no! #{data}"
			else
				msg.send "Great news! I created a new ticket."
				msg.send "The ticket can be found here: http://#{baseUrl}/projects/#{p}/tickets/#{data.ticket.ticketId[0]._} with the summary: #{data.ticket.summary}"
		)