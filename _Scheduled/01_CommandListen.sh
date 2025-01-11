#!/bin/bash

# Log file path
LOG_FILE="/Users/av/git/PTZControl/_Scheduled/scheduler.log"

# Logging function
log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

log "Running prep.sh equivalent"
open /Users/av/git/PTZControl/_Scheduled/01_CommandWrapped.sh

# Run prep.sh equivalent to prep the environment
log "Running prep.sh equivalent"
open /Users/av/git/PTZControl/orderMac/prep.sh