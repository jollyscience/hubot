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
# report codebase users - 'These are the users I know about...'
# report codebase activity - 'Here are the latest 20 updates.'
# report codebase projects - 'These are all of the projects I can find.'
# report codebase project <permalink> - 'Here is what I know about <permalink>'
# create codebase project <Full Project Name> - 'New Project created!'
# delete codebase project <permalink> - 'Permanently delete the project?'
# create codebase ticket in project <permalink> with summary <summary> - 'New ticket created! Here is the link.'
# report codebase open tickets in project <permalink> - 'Here are the open tickets I found...'
# report codebase updates to ticket <ticket_id> in project <permalink> - 'That ticket has XX updates. Here they are...'

Codebase = require('node-codebase')
_ = require('underscore')

module.exports = (robot) ->

	baseUrl = process.env.HUBOT_CODEBASE_BASEURL || 'jollyscience.codebasehq.com'
	apiUrl = process.env.HUBOT_CODEBASE_APIURL || 'api3.codebasehq.com'
	auth = process.env.HUBOT_CODEBASE_APIAUTH || 'jollyscience/jollyscience:3kqo5bdat3uln2bnv90mvvti1stuonjg99bnz1p4'

	cb = new Codebase(
		apiUrl, auth
	)

# ROBOT RESPONDERS

# REPORT USERS
	robot.respond /report codebase users/i, (msg) ->
		msg.send 'Okay. I\'ll go get a list of all Codebase users...'

		cb.users.all( (err, data) ->
			if (err)
				errmsg = JSON.stringify(data)
				msg.send "Oh no! #{errmsg}"

			else
				r = []
				ul = data.users.user
				for user in ul then do (user) =>
					if _.isObject(user.company[0])
						co = 'Freelance'
					else
						co = user.company.join(', ')

					knownusers = robot.brain.usersForFuzzyName(user.firstName)
					u = "not found"
					if knownusers.length is 1
						u = knownusers[0]

					r.push "#{user.username} | #{user.firstName} #{user.lastName} (#{co}) - #{u}"
      				# robot.brain.emit "new-alias", { context: 'codebase', alias: user }
					# console.log "USER: " + user

				msg.send r.join('\n')
		)

# REPORT ALL ACTIVITY
	robot.respond /report codebase activity/i, (msg) ->
		msg.send 'Okay. I\'m checking for codebase activity...'

		cb.activity( (err, data) ->
			if (err)
				errmsg = JSON.stringify(data)
				msg.send "Oh no! #{errmsg}"

			r = []
			for item in data.events.event then do (item) =>
				r.push "#{item.timestamp} - #{item.title}"

			msg.send r.join("\n")
		)

# REPORT SINGLE PROJECT
	robot.respond /report codebase project (.*)/i, (msg) ->
		msg.send 'Okay. I am searching the haystack for ' + msg.match[1]

		cb.projects.specific( msg.match[1], (err, data) ->
			if (err)
				errmsg = JSON.stringify(data)
				msg.send "Oh no! #{errmsg}"

			p = data.project
			p.overview = 'No Description' if !_.isString(p.overview)
			msg.send "#{p.name} is an #{p.status} project in the #{p.groupId} group, and is described as #{p.overview}."
			msg.send "You can visit the project on Codebase here: http://#{baseUrl}/projects/#{p.permalink}"
		)

# REPORT ALL PROJECTS
	robot.respond /report codebase projects/i, (msg) ->
		msg.send 'Okay. I am checking for codebase projects...'

		cb.projects.all( (err, data) ->
			if (err)
				errmsg = JSON.stringify(data)
				msg.send "Oh no! #{errmsg}"

			r = ['The Codebase projects I know about are as follows:']
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
				errmsg = JSON.stringify(data)
				msg.send "Oh no! #{errmsg}"

			else
				project = data.project
				msg.send "Project Created!\n#{project.name} - #{project.permalink}"
		)

# DELETE PROJECT
	robot.respond /delete codebase project (.*)/i, (msg) ->
		msg.send 'I am not allowed do that right now. It is just too unsafe.'
		# cb.projects.deleteProject( msg.match[1], (err, data) ->
		# 	if (err)
		# 		e = JSON.stringify(data.data)
		# 		msg.send ('Awe man... I messed up... #{e}')

		# 	msg.send JSON.stringify(data)
		# )

# GET OPEN TICKETS
	robot.respond /report codebase open tickets in project ([a-z_0-9-]+)/i, (msg) ->
	# robot.respond /cb report open tix in ([a-z_0-9-]+)/i, (msg) ->
		p = msg.match[1]
		msg.send "Okay. I\'ll look up open tickets in #{p}..."

		cb.tickets.allQuery(p, {query: 'resolution:open', page: 1}, (err, data) ->
			if (err)
				errmsg = JSON.stringify(data)
				msg.send "Oh no! #{errmsg}"
			else
				r = []
				msg.send "found some..."
				tix = data.tickets.ticket
				for ticket in tix then do (ticket) =>
					ticket.assignee = 'Unassigned' if !_.isString(ticket.assignee)
					r.push "##{ticket.ticketId[0]._} (#{ticket.ticketType}) | #{ticket.summary}\n[#{ticket.reporter} -> #{ticket.assignee}]\n---"

				m = r.join('\n')
				msg.send "Here are the open tickets I found: \n#{m}"
		)

# GET TICKET UPDATES
	robot.respond /report codebase updates to ticket ([0-9]+) in project ([a-z_0-9-]+)/i, (msg) ->
		t = msg.match[1]
		p = msg.match[2]

		msg.send "Okay. I\'ll try to find ticket #{t} in #{p}"

		cb.tickets.notes.all( p, t, (err, data) ->
			if (err)
				errmsg = JSON.stringify(data)
				msg.send "Oh no! #{errmsg}"

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

		msg.send "Okay. I\'ll try to create a new ticket in #{p} with a summary of \'#{s}\'"
		
		cb.tickets.create( p, { summary: s, description: 'DUMMY Description'}, (err, data) ->
			if (err)
				errmsg = JSON.stringify(data)
				msg.send "Oh no! #{errmsg}"
			else
				msg.send 'Great news! I created a new ticket.'
				msg.send "The ticket can be found here: http://#{baseUrl}/projects/#{p}/tickets/#{data.ticket.ticketId[0]._} with the summary: #{data.ticket.summary}"
		)

# MY Stuff
	robot.respond /report codebase my open tickets in project ([a-z_0-9-]+)/i, (msg) -> 
		project = msg.match[1]
		me = msg.message.user.name
		user = robot.brain.userForName(me)

		msg.reply "Okay. #{me} I\'ll look for your open tickets..."
		console.log user