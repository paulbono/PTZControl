#!/bin/bash

echo "Starting in 15 seconds"
sleep 15

# Start OBS
open -a "/Applications/OBS.app" || echo "OBS not found. Verify path."

# Wait 5 seconds
sleep 5

# Start Companion
open -a "/Applications/Companion.app" || echo "Companion not found. Verify path."

# Wait 15 seconds
sleep 15

# Start Stream Deck and Chrome with specific profiles and URLs
open -a "/Applications/Elgato Stream Deck.app" || echo "Stream Deck not found. Verify path."
open -na "/Applications/Google Chrome.app" --args --profile-directory="Profile 1" http://10.0.0.132/ -incognito
open -na "/Applications/Google Chrome.app" --args --profile-directory="Profile 1" http://10.0.0.154/ -incognito

# Run WrapperScript On.sh
echo "Running WrapperScript On.sh"
bash /Users/av/git/PTZControl/WrapperScriptMac/On.sh

# Run query.sh
echo "Running query.sh"
bash /Users/av/git/PTZControl/WrapperScriptMac/query.sh
