# Description:
#   Directs curious MegaMinerAI participants about where the documentation is located.
#
# Commands:
#   where can i find the documentation?
#   where can i find documentation?
#   where are the docs?
#   where is the documentation?
#


module.exports (robot) ->
  robot.respond /^(?:(where)(?!.* in .*).* )?doc(?:s|umentation)\?$/i, (msg) ->
    msg.reply "you can find the MegaMinerAI Documentation at http://docs.megaminerai.com"
