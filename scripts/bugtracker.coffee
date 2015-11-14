# Description:
#   Allow a github issue to be added by any person in the irc channel. This issue will be sent to the github megaminerai 16 issue page.
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   __bort__ report bug <title>: <server> - title and body of github issue
#
# Author:
#   AlexMarey
#   michaelwisely

_ = require "underscore"
GitHubAPI = require "github"

# Configuration Options
config =
    cred:
        token: process.env.HUBOT_ISSUE_GITHUB_TOKEN
    repo:
        name: process.env.HUBOT_ISSUE_REPO_NAME
        owner: process.env.HUBOT_ISSUE_REPO_OWNER
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
        labels: config.bug_labels

    github.issues.create options, (err, result) ->
        if err
            throw new IssueError("Error creating file: #{err}")
        done result

module.exports = (robot) ->
    # Sanity check our required variables
    unless config.repo.name?
        robot.logger.warning "HUBOT_ISSUE_REPO_NAME variable is not set."
    unless config.repo.owner?
        robot.logger.warning "HUBOT_ISSUE_REPO_OWNER variable is not set."
    unless config.cred.token?
        robot.logger.warning "HUBOT_ISSUE_GITHUB_TOKEN variable is not set."

    robot.respond /report bug (.*): (.*)/i, (msg) ->
        username = msg.user.name if msg.user
        title = msg.match[1]
        body = "#{msg.match[2]}\n\nReported by #{username}"

        submitIssue title, body, (done) ->
            msg.reply "Submitted issue."
