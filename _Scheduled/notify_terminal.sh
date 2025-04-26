#!/bin/bash

# Grab title and message from args
TITLE="$1"
MESSAGE="$2"

# If no args, show usage and exit
if [ -z "$TITLE" ] || [ -z "$MESSAGE" ]; then
  echo "Usage: $0 \"Title\" \"Message\""
  exit 1
fi

# Send the notification
terminal-notifier -title "$TITLE" -message "$MESSAGE"
