# Description:
#   Lists devs for competitors
#
# Commands:
#   hubot who are the devs? - Lists the developers
#   hubot is <username> a dev? - Indicates if <username> is a dev

module.exports = (robot) ->

    robot.respond /who (?:is|are) (?:a|the) devs?/i, (msg) ->
        devs = (robot.auth.usersWithRole "dev").join(", ")
        msg.reply "The devs are #{devs}"

    robot.respond /(?:is|are) (\w+) (?:a|the) devs?/i, (msg) ->
        candidate = msg.match[1]
        user = robot.brain.userForName candidate.toLowerCase()
        if user? and robot.auth.hasRole user, "dev"
            msg.reply "Yes. #{candidate} is a dev."
        else
            msg.reply "No. #{candidate} is not a dev."
