# Description:
#   Make sure that hubot knows the rules.
#
# Commands:
#   hubot the rules - Make sure hubot still knows the rules.
#
# Notes:
#   DON'T DELETE THIS SCRIPT! ALL ROBAWTS MUST KNOW THE RULES

howtoshoot = [
  "1. Ready",
  "2. Aim",
  "3. Fire"
  ]

module.exports = (robot) ->
  robot.respond /how do you shoot a gun/i, (msg) ->
    msg.send howtoshoot.join('\n')