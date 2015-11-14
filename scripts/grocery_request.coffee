# Description:
#   Request food
#
# Commands:
#   hubot me want <food>! - Adds an item to the grocery list

_ = require "underscore"

showList = (items) ->

  """
<!DOCTYPE html>
<html>
  <head>
  <meta charset="utf-8">
  <title>Food Requests</title>
  <style type="text/css">
    body {
      background: #d3d6d9;
      color: #636c75;
      text-shadow: 0 1px 1px rgba(255, 255, 255, .5);
      font-family: Helvetica, Arial, sans-serif;
    }
    h1 {
      margin: 8px 0;
      padding: 0;
    }
    li {
      font-size: 16px;
    }
  </style>
  </head>
  <body>
    <h1>Food Requests</h1>
    #{items}
  </body>
</html>
  """

module.exports = (robot) ->

    robot.respond /me want ([\w\s]{1,30})/i, (msg) ->
        item = _.escape msg.match[1]

        groceries = robot.brain.get "groceryList"
        groceries ?= []
        groceries.push(item)
        groceries = _.uniq(groceries, false)
        robot.brain.set "groceryList", groceries

        msg.reply "Added #{item} to list"

    robot.router.get "/#{robot.name}/groceries", (req, res) ->
        groceries = robot.brain.get "groceryList"
        groceries ?= []

        list = _.map groceries, (x) -> "<li>#{x}</li>"

        res.setHeader 'content-type', 'text/html'
        res.end showList "<ul>#{list.join('')}</ul>"
