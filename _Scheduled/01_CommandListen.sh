#!/bin/bash

# Log file path
LOG_FILE="/Users/av/git/PTZControl/_Scheduled/scheduler.log"

# Logging function
log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

# Start Node.js PTZControl SlideListener script in the background
log "Starting PTZControl SlideListener"
cd /Users/av/git/PTZControl/SlideListener || { log "PTZControl SlideListener directory not found."; exit 1; }
node index.js >> "$LOG_FILE" 2>&1 &  # Run in background and log output

# Wait a moment to ensure the listener starts properly
sleep 2

# Run Streaming.ahk equivalent (replace with Mac-compatible version if needed)
# Uncomment and modify the following line if there's a Mac equivalent
# log "Running Streaming.ahk equivalent"
# ./path/to/streaming_script.sh >> "$LOG_FILE" 2>&1

# Wait 3 seconds
sleep 3

# Run prep.sh equivalent to prep the environment
log "Running prep.sh equivalent"
open /Users/av/git/PTZControl/orderMac/prep.sh >> "$LOG_FILE" 2>&1
