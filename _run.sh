#!/bin/bash

export HUBOT_HIPCHAT_JID="35604_343802@chat.hipchat.com"
export HUBOT_HIPCHAT_PASSWORD="J05i-hubot"
export HUBOT_AUTH_ADMIN="245953,245954,246044"
#export HUBOT_LOG_LEVEL="debug"
export PORT="808080"
export HUBOT_HARVEST_SUBDOMAIN="jollyscience"
#export MONGOLAB_URI="mongodb://josi:Wresp2T2@localhost:27017"

#bin/hubot --adapter hipchat
bin/hubot
