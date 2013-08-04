# Description:
#   Handles all messages sent to JoSi. Remembers the last 10 messages per user per room, and
#   her responses to them.
#
# Dependencies:
#   node-codein
#
# Configuration:
#   None

codein = require("node-codein")

{HubotCache} = require("hubot-cache")

module.exports = (robot) ->
  cache = new HubotCache(robot)
  GLOBAL._cache = cache
  
  robot.hear /josi[,\s]+(.+)/i, (msg) ->
    real_message = msg.match[1]
    msg.message.text = "#{msg.robot.name} #{real_message}"
    
    cache.recordMessage(msg)   
    
    unless cache.respondCache(msg) then msg.robot.receive msg.message
  
  robot.hear /^remember that$/i, (msg) ->
    if cache.cacheResponse msg
      msg.send "Great, I'll cache my response to that"
    else msg.send "There's nothing for me to remember"