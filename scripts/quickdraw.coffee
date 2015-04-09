# Description:
#   A script to remind MegaMinerAI competitors in about when the quickdraw tournament
#   will begin
#
# Dependencies:
#   "moment"
#
# Configuration:
#   None
#
# Commands:
#   bort quickdraw at <goal_time> (in 24 hrs)

module.exports = (robot) ->
  robot.respond /(quickdraw) (at) ([01]?[0-9]|2[0-3]):([0-5][0-9])/i, (msg) ->
    # read desired time
    hours = msg.match[3]
    minutes = msg.match[4]

    # get current date
    now = moment(new Date())
    currYear = now.year()
    currMonth = now.month()
    currDay = now.day()
        
    # build date object for future
    future = moment(new Date(currYear, currMonth, currDay, hours, minutes, 0, 0))

    # time left until future time
    diff = new Date(future - now)
    diffHrs = diff.getHours()
    diffMins = diff.getMinutes()

    msg.send "quickdraw in #{diffHrs} hour(s) and #{diffMins} minute(s)"
