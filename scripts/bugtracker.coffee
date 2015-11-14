# Description:
#   Allows authorized reporters to report bugs to GitHub
#
# Dependencies:
#   "github": "^0.2.4"
#   "hubot-auth": "^1.2.0"
#
# Configuration:
#   HUBOT_ISSUE_GITHUB_TOKEN - The GitHub token to use for reports
#   HUBOT_ISSUE_REPO_NAME - The repo that's getting the issues
#   HUBOT_ISSUE_REPO_OWNER - The owner of said repo
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   Only users with the "reporter" role in hubot-auth can report


_ = require "underscore"
GitHubAPI = require "github"

# Configuration Options
config =
    cred:
        token: process.env.HUBOT_ISSUE_GITHUB_TOKEN
    repo:
        name: process.env.HUBOT_ISSUE_REPO_NAME
        owner: process.env.HUBOT_ISSUE_REPO_OWNER
    reporter_role: "reporter"
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
        user = msg.envelope.user

        unless robot.auth.hasRole user, config.reporter_role
            msg.reply "Sorry! You need the #{config.reporter_role} role to report bugs."
            return

        title = msg.match[1]
        body = "#{msg.match[2]}\n\nReported by #{user.name}"

        msg.reply "OK, I'll tell a dev."
        submitIssue title, body, (done) ->
            msg.reply "Submitted issue."
