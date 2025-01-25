#!/bin/bash

# Log file path
LOG_FILE="/Users/av/git/PTZControl/_Scheduled/scheduler.log"

# Logging function
log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

log "Starting initialization sequence with a 15-second delay."
sleep 15

# Start OBS
log "Starting OBS"
open -a "/Applications/OBS.app" >> "$LOG_FILE" 2>&1 || log "OBS not found. Verify path."

# Wait 5 seconds
sleep 5

# Start Companion
log "Starting Companion"
open -a "/Applications/Companion.app" >> "$LOG_FILE" 2>&1 || log "Companion not found. Verify path."

# Wait 15 seconds
sleep 15

# Start Stream Deck and Safari with specific URLs
log "Starting Stream Deck"
open -a "/Applications/Elgato Stream Deck.app" >> "$LOG_FILE" 2>&1 || log "Stream Deck not found. Verify path."

log "Opening Safari with specified URLs"
open -na "/Applications/Safari.app" "http://10.0.0.132" >> "$LOG_FILE" 2>&1
open -na "/Applications/Safari.app" "http://10.0.0.95" >> "$LOG_FILE" 2>&1

# Run WrapperScript On.sh
log "Running WrapperScript On.sh"
open /Users/av/git/PTZControl/WrapperScriptMac/On.sh >> "$LOG_FILE" 2>&1 || log "On.sh not found. Verify path."

# Run query.sh
log "Running query.sh"
open /Users/av/git/PTZControl/WrapperScriptMac/query.sh >> "$LOG_FILE" 2>&1 || log "query.sh not found. Verify path."
