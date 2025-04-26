#!/bin/bash

# Optional log file (or leave blank if you only want terminal output)
LOG_FILE="./test_terminal_close.log"

# Logging function
log() {
    echo "$(date): $*" | tee -a "$LOG_FILE"
}

# Start
log "Starting test: Closing other Terminal windows (except current one)"

# AppleScript: Close other Terminal tabs/windows
osascript <<EOF
tell application "Terminal"
    set theWindows to every window
    repeat with w in theWindows
        if w is not front window then
            try
                close w
            end try
        end if
    end repeat
end tell
EOF

log "AppleScript executed — other Terminal windows should now be closed."
