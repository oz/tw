#!/usr/bin/env coffee

argv = require('optimist').argv
http = require 'http'
URL  = require 'url'
PROG_NAME = 'tw'

if argv.h
  console.log "Usage: "+PROG_NAME+" <tweet url | tweet id>"
  console.log " -h                          show help"
  console.log " -u <nick>                   user's tweets"
  console.log " -s <search term>            search tweets"
  console.log " -i <status id | status url> show status\n"
  process.exit()

##
# Fetch JSON from Twitter API, and call cb with the parsed JSON object
# unless Twitter sends us an error...
#
# @param [String] path API Path or complete URL
# @param [Function] cb Callback receiving Twitter's response as an Object
fetch = (path, cb) ->
  show_error = (obj) -> console.log "Error: " + (obj.message || obj.error)
  if path.match(/^http/) && url = URL.parse(path)
    options =
      host: url.hostname
      post: (url.protocol == 'https' ? 443 : 80)
      path: url.pathname + url.search
  else
    options =
      host: "api.twitter.com"
      post: 443
      path: path

  req = http.get options, (res) ->
    res.setEncoding "utf8"
    buf = ""
    res.on "data",  (chunk) -> buf += chunk
    res.on "end",   ()      ->
      o = JSON.parse buf
      if o.error
        console.log "Error: " + o.error
      else
        cb o
  req.on "error", (e) -> show_error e

##
# Fetch a user's statuses
# @param [String] screen_name User's screen name
viewUserStatuses = (screen_name) ->
  path = "/1/statuses/user_timeline.json?screen_name=" + screen_name
  fetch path, (tweets) -> tweets.map (e) -> displayTweet e

##
# Fetch one status by ID
# @param [String] status_id A status ID
viewStatus = (status_id) ->
  path = "/1/statuses/show/" + status_id + ".json"
  fetch path, (tweet) -> displayTweet tweet

##
# Search tweets
# @param [String] query Search query
searchTweets = (query) ->
  uri = 'https://search.twitter.com/search.json?q='+query
  fetch uri, (response) ->
    response.results ||= []
    response.results.map (r) ->
      displayTweet
        created_at: r.created_at,
        user:
          screen_name: r.from_user,
        text: r.text

##
# Display a single tweet
# @param [Object] tweet A tweet object fresh from Twitter's API
displayTweet = (tweet) ->
  d = new Date tweet.created_at
  date = ['Date' , 'Month'  , 'FullYear'].map (n) -> d['getUTC'+n]()
  time = ['Hours', 'Minutes', 'Seconds' ].map (n) -> d['getUTC'+n]()
  date_str = date.join('/') + ' ' + time.join(':') + ' UTC'
  console.log tweet.user.screen_name + " (" + date_str + "): " + tweet.text + "\n"

##
# Args dispatching's done here.
viewUserStatuses argv.u if argv.u
searchTweets     argv.s if argv.s
viewStatus       argv.i if argv.i
# Handle <tw 123123123> and/or <tw "http://..../status/123123213">
if argv._.length == 1 && matches = (""+argv._[0]).match(/(status\/)?(\d+)\/?/)
  viewStatus matches[2]
