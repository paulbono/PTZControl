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
node index.js   # Run in background and log output

