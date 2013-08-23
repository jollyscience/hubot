# Description:
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   hubot i am <alias> on <context> - adds / updates your alias within the given context
#   hubot forget me on <context> - removes your alias from <context>
#   hubot who am i on <context> - shows your alias on <context>
#   hubot show my alias(es)? - lists all of your aliases across contexts
#   hubot show all alias(es)? - lists all users aliases across contexts
#   hubot show my context <context> - shows your details within the context of <context>
#   hubot clear my alias(es)? - removes all of your aliases across contexts
#   hubot update context <context> with (key|url|name) <alias> - updates the details of your <context> with special features, including key and url
# Notes:
#
# Author:
#   meshachjackson

module.exports = (robot) ->

# API
  class Alias

    model: (_args) ->
      {
        name: _args.name or ''
        url: _args.url or ''
        key: _args.key or ''
      }

    getMe: (msg) ->
      robot.brain.userForName(msg.message.user.name)

    setAlias: (msg) ->
      alias = msg.match[1]
      context = msg.match[2]
      user = @getMe(msg)
      user.aliases = user.aliases or {}
      user.aliases[context] = @model({ name: alias })
      "You are now known as #{alias} on #{context}"

    updateMyAlias: (msg) ->
      context = msg.match[1]
      prop = msg.match[2]
      val = msg.match[3]
      user = @getMe(msg)
      c = user.aliases[context]
      c[prop] = val
      "You are now known as #{c.name} on #{context} with #{prop} as #{val}"

    forgetAlias: (msg) ->
      context = msg.match[1]
      user = @getMe(msg)
      user.aliases = user.aliases or {}
      user.aliases[context] = {}
      "You are now known as undefined on #{context}"

    getAlias: (msg) ->
      context = msg.match[1]
      user = @getMe(msg)
      alias = user.aliases[context]
      if (alias)
        "You are known as #{alias.name} on #{context}"
      else
        "You are not known in that context."

    showMyContext: (msg) ->
      context = msg.match[1]
      user = @getMe(msg)
      a = user.aliases[context]

      if (a)
        astr = JSON.stringify(a)
        "Here is what I know about the #{context} context:\n#{astr}"
      else
        "You are not known in that context."

    listAllAlias: (msg) ->
      theReply = [ ]
      theReply.push("Here are the aliases I know:")

      for own key, user of robot.brain.users()
        if(user.aliases)
          alist = [ ]
          for own context, alias of user.aliases
            alist.push("\'#{alias.name}\' on #{context}")
          astr = alist.join(', and by ')
          theReply.push("- #{user.name} goes by #{astr}")

      theReply.join('\n') + "."
  
    listMyAlias: (msg) ->
      user = @getMe(msg)
      if (user.aliases)
        theReply = [ ]
        theReply.push("Here are the ways you are known:")
        alist = [ ]
        for own context, alias of user.aliases
          alist.push("\'#{alias.name}\' on #{context}")
        astr = alist.join(', and by ')
        theReply.push("You are known as #{astr}")
        theReply.join('\n') + "."
      else
        "You don\'t have any aliases."
  
    clearMyAliases: (msg) ->
      user = @getMe(msg)
      user.aliases = {}
      "Hope you knew what you were doing!"

# ROUTES
  robot.respond /i am ([a-z0-9-]+) on ([a-z0-9-]+)/i, (msg) ->
    robot.alias = robot.alias or new Alias
    msg.send robot.alias.setAlias(msg)

  robot.respond /forget me on ([a-z0-9-]+)/i, (msg) ->
    robot.alias = robot.alias or new Alias
    msg.send robot.alias.forgetAlias(msg)

  robot.respond /who am i on ([a-z0-9-]+)/i, (msg) ->
    robot.alias = robot.alias or new Alias
    msg.send robot.alias.getAlias(msg)

  robot.respond /show my alias(es)?/i, (msg) ->
    robot.alias = robot.alias or new Alias
    msg.send robot.alias.listMyAlias(msg)

  robot.respond /show all alias(es)?/i, (msg) ->
    robot.alias = robot.alias or new Alias
    msg.send robot.alias.listAllAlias(msg)

  robot.respond /show my context ([a-z0-9-]+)/i, (msg) ->
    robot.alias = robot.alias or new Alias
    msg.send robot.alias.showMyContext(msg)

  robot.respond /clear my alias(es)?/i, (msg) ->
    robot.alias = robot.alias or new Alias
    msg.send robot.alias.clearMyAliases(msg)

  robot.respond /update context ([a-z0-9-]+) with (key|url|name) ([a-z0-9-]+)/i, (msg) ->
    robot.alias = robot.alias or new Alias
    msg.send robot.alias.updateMyAlias(msg)

# listeners
  robot.brain.on "alias_context_update", (args) ->
    robot.alias = robot.alias or new Alias
    args.msg.send "NEW ALIAS!\nTODO: store the users in the default \'cache\' location, to avoid double-storage.\nTODO: check for cached results before checking the api (BUT STILL EMIT EVENTS)\nTODO: sync users from HipChat with the users on Codebase, so we can begin to link identities."