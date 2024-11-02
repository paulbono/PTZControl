#!/bin/bash

echo "Starting in 15 seconds"
sleep 15


# Start Node.js PTZControl SlideListener script
echo "Starting PTZControl SlideListener"
cd /Users/av/git/PTZControl/SlideListener || echo "PTZControl SlideListener directory not found."
node index.js

# Wait for OBS to start fully
sleep 300

# Run Streaming.ahk equivalent (if applicable, otherwise replace with Mac-compatible version)
echo "Running Streaming.ahk equivalent"
# ./path/to/streaming_script.sh

# Wait 3 seconds
sleep 3

# Run prep.bat equivalent
echo "Running prep.bat equivalent"
# ./path/to/prep_script.sh
