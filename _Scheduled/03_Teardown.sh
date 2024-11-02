#!/bin/bash

# Run Off.bat equivalent script
# echo "Running Off.bat equivalent"
bash /Users/av/git/PTZControl/WrapperScriptMac/Off.sh

# Wait 5 seconds
sleep 5

# Kill the apps we started
pkill -f "OBS"
pkill -f "Companion"
pkill -f "Google Chrome"

# Logoff in 30 seconds
echo "Logging off in 30 seconds"
sleep 30

# Log off from the computer
osascript -e 'tell application "System Events" to log out'
