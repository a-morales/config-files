#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title todo
# @raycast.mode silent
# @raycast.packageName bujo

# Optional parameters:
# @raycast.icon ☑️
# @raycast.argument1 { "type": "text", "placeholder": "text" }

rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
    c=${string:$pos:1}
    case "$c" in
      [-_.~a-zA-Z0-9] ) o="${c}" ;;
      * )               printf -v o '%%%02x' "'$c"
    esac
    encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

open "noteplan://x-callback-url/addText?noteDate=today&mode=append&text=$( rawurlencode "* $1" )"
