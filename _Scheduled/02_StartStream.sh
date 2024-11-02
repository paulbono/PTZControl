#!/bin/bash

# Log file path
LOG_FILE="/Users/av/git/PTZControl/_Scheduled/scheduler.log"

# Logging function
log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

# Start streaming script
log "Starting startStream.sh"
open /Users/av/git/PTZControl/WrapperScriptMac/startStream.sh >> "$LOG_FILE" 2>&1 || log "startStream.sh not found. Verify path."
