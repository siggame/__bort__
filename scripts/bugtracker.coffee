# Description:
#   Bug Tracker for Megaminer AI
#
# Commands:
#   bort bug <description> - Report a bug, submits a github issue to https://github.com/siggame/bort/ and marks it as competitor.
#   
#
# URLS:
#   /hubot/help
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.
#
# Adapted from https://github.com/hubot-scripts/hubot-help/
#

module.exports = (robot) ->
    robot.respond /^report bug (.*)/i
        bug = escape(msg.match[1])
