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

{Conversation, ConversationEntry} = require("hubot-cache")

module.exports = (robot) ->
  robot.Response.prototype.send = (strings...) ->
    console.log strings
    if @message.conversation_entry?
      @message.conversation_entry.response = @message.conversation_entry.response.concat strings

    @robot.adapter.send @envelope, strings...

  options =
    lines_to_keep:  10

  conversation = new Conversation(robot, options.lines_to_keep)

  GLOBAL.conversation = conversation

  robot.hear /josi[,\s]+(.+)/i, (msg) ->
    real_message = msg.match[1]
    msg.message.text = "#{msg.robot.name} #{real_message}"
    msg.message.is_forwaded = true
    
    msg.message.conversation_entry = new ConversationEntry msg
    conversation.add(msg.message.conversation_entry)
    
    
    
    if @robot.brain.data.cachedResponses? and @robot.brain.data.cachedResponses[real_message]?
      @robot.brain.data.cachedResponses[real_message](msg)
    else
      msg.robot.receive msg.message
  
  robot.hear /^remember that$/i, (msg) ->
    lastMessage = conversation.lastEntry msg.message.user.room, msg.message.user.name
    
    if lastMessage  
      responses = lastMessage.response.join("\n")
  #     msg.robot.receive msg.message
      
      msg.send "Great, I'll cache my answer to \"#{lastMessage.text}\""
            
      @robot.brain.data.cachedResponses ?= {}
      @robot.brain.data.cachedResponses[lastMessage.text] = (msg) ->
        msg.send responses
    
    else msg.send "There's nothing for me to remember"