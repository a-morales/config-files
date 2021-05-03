#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title /r
# @raycast.mode silent
# @raycast.packageName Web Searches

# Optional parameters:
# @raycast.icon 👽
# @raycast.argument1 { "type": "text", "placeholder": "subreddit" }

open "https://reddit.com/r/$1"
