#!/bin/bash

# Log file path
LOG_FILE="/Users/av/git/PTZControl/_Scheduled/scheduler.log"

# Logging function
log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

# Run Off.sh equivalent script
log "Running Off.sh equivalent"
open /Users/av/git/PTZControl/WrapperScriptMac/Off.sh >> "$LOG_FILE" 2>&1 || log "Off.sh not found. Verify path."

# Wait 5 seconds
sleep 5

# Kill the apps we started
log "Terminating OBS"
pkill -f "OBS" && log "OBS terminated" || log "OBS was not running."

log "Terminating Companion"
pkill -f "Companion" && log "Companion terminated" || log "Companion was not running."

log "Terminating Safari"
pkill -f "Safari" && log "Safari terminated" || log "Safari was not running."

# Wait 30 seconds before opening the file
log "Waiting 30 seconds before opening AutomationInProgress.txt"
sleep 30

# Open AutomationInProgress.txt in TextEdit
log "Opening AutomationInProgress.txt in TextEdit"
open -a "TextEdit" "/Users/av/Documents/AutomationInProgress.txt" >> "$LOG_FILE" 2>&1 || log "AutomationInProgress.txt not found. Verify path."

# Commit changes to Git repository for weekly inspection
log "Adding and committing changes to Git repository"
/usr/bin/git -C /Users/av/git/PTZControl/ add . >> "$LOG_FILE" 2>&1
/usr/bin/git -C /Users/av/git/PTZControl/ commit -m "latest log files for sampling" >> "$LOG_FILE" 2>&1 || log "No changes to commit."

log "Git commit completed. Logs available for inspection."
