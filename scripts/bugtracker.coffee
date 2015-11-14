# Description:
#   <description of the scripts functionality>
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>

_ = require "underscore"
GitHubAPI = require "github"

# Configuration Options
config =
    cred:
        token: process.env.HUBOT_STATUS_GITHUB_TOKEN
    repo:
        name: process.env.HUBOT_STATUS_REPO_NAME
        owner: process.env.HUBOT_STATUS_REPO_OWNER
    bug_labels: ["competitor"]

# API Helper
github = new GitHubAPI
    version: "3.0.0"
    debug: false
    protocol: "https"
    timeout: 5000
    headers:
        "user-agent": "SIG-Game-Hubot-Bort"

# Authenticate if possible
if config.cred.token?
    github.authenticate
        type: "oauth"
        token: config.cred.token

class IssueError
    ###
    An Error class for throwing
    ###
    constructor: (@message) ->


submitIssue = (title, body, done) ->
    ###
    Submit a status update to GitHub
    ###
    options =
        user: config.repo.owner
        repo: config.repo.name
        title: title
        body: body
        branch: "master"
        labels: config.bug_labels

    github.issues.create options, (err, result) ->
        if err
            throw new IssueError("Error creating file: #{err}")
            done result

module.exports = (robot) ->
    robot.respond /report bug (.*): (.*)/i, (msg) ->
        username = msg.user.name if msg.user
        title = msg.match[1]
        body = "#{msg.match[2]}\n\nReported by #{username}"
        msg.send "#{title}\n#{body}"
