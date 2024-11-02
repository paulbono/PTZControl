#!/bin/bash

# Log file path
LOG_FILE="/Users/av/git/PTZControl/_Scheduled/scheduler.log"
DB_FILE="/Users/av/git/PTZControl/_Scheduled/scheduler.db"

# Logging function
log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

log_to_db() {
    local job_name="$1"
    local status="$2"
    local message="$3"

    # Ensure the job exists in the jobs table
    sqlite3 "$DB_FILE" <<EOF
    INSERT OR IGNORE INTO jobs (job_name, last_run, status, message) VALUES ('$job_name', NULL, NULL, NULL);
    INSERT INTO job_history (job_id, run_time, status, message)
    VALUES ((SELECT id FROM jobs WHERE job_name='$job_name'), datetime('now'), '$status', '$message');
    UPDATE jobs SET last_run=datetime('now'), status='$status', message='$message'
    WHERE job_name='$job_name';
EOF
}

# Helper to convert cron to human-readable format
cron_to_human() {
    local cron_entry="$1"
    echo "$cron_entry" | awk '{print "Minute:", $1, "| Hour:", $2, "| Day of Month:", $3, "| Month:", $4, "| Day of Week:", $5}'
}

# Check if script exists and is executable
prompt_executable_path() {
    while true; do
        read -p "Enter the path to the script or executable: " exec_path
        if [[ -f "$exec_path" && -x "$exec_path" ]]; then
            log "Executable found and is valid: $exec_path"
            break
        else
            log "Invalid path or not executable: $exec_path"
            echo "Path is invalid or not executable. Please try again."
        fi
    done
}


# Schedule the task
schedule_task() {
    local exec_path job_name task_type cron_time

    if [ "$1" ] && [ "$2" ] && [ "$3" ]; then
        exec_path="$1"
        job_name="$2"
        cron_time="$3"
        log "Scheduling task '$job_name' with cron timing '$cron_time' for path '$exec_path'."
    else
        prompt_executable_path
        read -p "Enter a name for the job (for easier identification): " job_name

        # Prompt for task type (one-off or recurring)
        echo "Choose task type:"
        echo "1) One-off"
        echo "2) Recurring"
        read -p "Enter choice (1 or 2): " task_type

        if [[ "$task_type" == "1" ]]; then
            # One-off task
            read -p "Enter the date (YYYY-MM-DD) and time (HH:MM) in Central Time for the one-off task: " date time
            cron_time=$(TZ="$TIMEZONE" date -j -f "%Y-%m-%d %H:%M" "$date $time" "+%M %H %d %m *")
            log "Scheduling one-off task '$job_name' at $cron_time"
        elif [[ "$task_type" == "2" ]]; then
            # Recurring task
            echo "Enter schedule frequency (e.g., daily, weekly, monthly):"
            echo "  - 'daily' to run every day at a specific time"
            echo "  - 'weekly' to run every week on a specific day/time"
            echo "  - 'monthly' to run on a specific date each month"
            read -p "Frequency: " frequency
            read -p "Enter time (HH:MM) in Central Time for the recurring task: " time

            cron_time=$(TZ="$TIMEZONE" date -j -f "%H:%M" "$time" "+%M %H")
            case $frequency in
                daily)
                    cron_time="$cron_time * * *"
                    ;;
                weekly)
                    read -p "Enter the day of the week (0=Sunday, 1=Monday, ... 6=Saturday): " day
                    cron_time="$cron_time * * $day"
                    ;;
                monthly)
                    read -p "Enter the day of the month (1-31): " day
                    cron_time="$cron_time $day * *"
                    ;;
                *)
                    log "Invalid frequency specified."
                    echo "Invalid frequency. Exiting."
                    return
                    ;;
            esac
            log "Scheduling recurring task '$job_name': $frequency at $cron_time"
        else
            log "Invalid task type selected."
            echo "Invalid choice. Exiting."
            return
        fi
    fi

    # Add task to crontab with a job name comment for identification
    local cron_entry="$cron_time $exec_path # $job_name >> $LOG_FILE 2>&1"
    (crontab -l; echo "$cron_entry") | crontab -
    log "Task scheduled with cron entry: $cron_entry"
    echo "Task scheduled successfully."
}


# Test the schedule by adding and removing a temporary job
test_schedule() {
    echo "Running test mode..."
    prompt_executable_path
    local cron_entry="* * * * * $exec_path >> $LOG_FILE 2>&1"

    # Add test job
    (crontab -l; echo "$cron_entry") | crontab -
    log "Test job added: $cron_entry"
    echo "Test job added. Waiting to verify..."

    # Wait and verify the job was added
    sleep 10  # Wait for 10 seconds for test job to execute
    if tail -n 10 "$LOG_FILE" | grep -q "$exec_path"; then
        log "Test job executed successfully."
        echo "Test job verified successfully."
    else
        log "Test job did not run as expected."
        echo "Test job verification failed."
    fi

    # Remove test job
    crontab -l | grep -v "$cron_entry" | crontab -
    log "Test job removed."
    echo "Test job removed."
}

# Start a job and log it
start_job() {
    local job_name="$1"
    local command="$2"
    
    log "Starting job: $job_name"
    eval "$command" >> "$LOG_FILE" 2>&1
    if [[ $? -eq 0 ]]; then
        log "Job '$job_name' completed successfully."
        log_to_db "$job_name" "SUCCESS" "Job ran successfully."
    else
        log "Job '$job_name' failed."
        log_to_db "$job_name" "FAILED" "Job encountered an error."
    fi
}

# View current cron jobs
view_jobs() {
    echo "Current cron jobs for $(whoami):"
    crontab -l | tee -a "$LOG_FILE"
}

# Manually run a job and log to database
manual_run() {
    echo "Available jobs:"
    crontab -l | grep "#" | awk -F'#' '{print $2}' | nl
    read -p "Enter the job number to run manually: " job_number

    # Extract job command
    job_command=$(crontab -l | grep "#" | awk -F'#' '{print $1}' | awk '{$1=$2=$3=$4=$5=""; print $0}' | sed 's/^ *//g' | sed -n "${job_number}p")
    job_name=$(crontab -l | grep "#" | sed -n "${job_number}p" | awk -F'#' '{print $2}' | sed 's/^ *//g')

    if [[ -z "$job_command" ]]; then
        echo "Invalid job number."
    else
        log "Manually executing job: $job_command"
        start_job "$job_name" "$job_command"
    fi
}

# Copy job to new time as a one-off
copy_job_one_off() {
    echo "Available jobs:"
    crontab -l | grep "#" | awk -F'#' '{print $2}' | nl
    read -p "Enter the job number to copy: " job_number

    # Extract job details
    cron_timing=$(crontab -l | grep "#" | awk 'NR=='"${job_number}"'{print $1, $2, $3, $4, $5}')
    job_command=$(crontab -l | grep "#" | awk '{$1=$2=$3=$4=$5=""; print $0}' | sed 's/^ *//g' | sed -n "${job_number}p")
    job_name=$(crontab -l | grep "#" | sed -n "${job_number}p" | awk -F'#' '{print $2}' | sed 's/^ *//g')

    # Get new timing for one-off
    read -p "Enter new timing (e.g., '0 8 * * *' for 8 AM): " new_timing
    if [[ -n "$new_timing" ]]; then
        cron_entry="$new_timing $job_command # ${job_name}_one_off"
        (crontab -l; echo "$cron_entry") | crontab -
        log "One-off job created with timing '$new_timing'."
    else
        log "Invalid timing entered. One-off job creation aborted."
    fi
}

# View job details, including last run info from SQLite
job_details() {
    echo "Current jobs:"
    echo "ID | Job Name           | Last Run           | Status      | Message"
    echo "-----------------------------------------------------------------------"
    
    # Query SQLite for all jobs
    sqlite3 "$DB_FILE" -separator "|" "SELECT id, job_name, last_run, status, message FROM jobs;" | \
    while IFS="|" read -r id job_name last_run status message; do
        printf "%-3s| %-18s| %-18s| %-11s| %s\n" "$id" "$job_name" "$last_run" "$status" "$message"
    done

    read -p "Enter job ID to view details, edit, delete, or run manually: " job_id
    job_entry=$(sqlite3 "$DB_FILE" "SELECT id, job_name, last_run, status, message FROM jobs WHERE id=$job_id;")

    if [[ -z "$job_entry" ]]; then
        echo "Invalid job ID."
        return
    fi

    # Extract job details from the SQLite entry
    job_name=$(echo "$job_entry" | cut -d'|' -f2)
    last_run=$(echo "$job_entry" | cut -d'|' -f3)
    status=$(echo "$job_entry" | cut -d'|' -f4)
    message=$(echo "$job_entry" | cut -d'|' -f5)

    echo "Details for job $job_id:"
    echo "Job Name    : $job_name"
    echo "Last Run    : $last_run"
    echo "Status      : $status"
    echo "Message     : $message"

    echo "Options:"
    echo "1) Edit job"
    echo "2) Delete job"
    echo "3) Run job manually"
    echo "4) Back to main menu"
    read -p "Choose an option: " choice

    case $choice in
        1)  # Edit Job
            echo "Editing job $job_id."
            read -p "Enter new cron timing (e.g., '* * * * *'): " new_cron
            read -p "Enter new command (or press enter to keep current): " new_command
            new_command="${new_command:-$job_name}"

            # Update crontab with new timing and command
            cron_entry="$new_cron $new_command # $job_name"
            (crontab -l | sed "${job_id}s@.*@$cron_entry@") | crontab -
            log "Job $job_id updated to: $cron_entry"
            echo "Job updated successfully."

            # Update the job in SQLite as well
            sqlite3 "$DB_FILE" <<EOF
            UPDATE jobs SET job_name='$new_command' WHERE id=$job_id;
EOF
            ;;
        2)  # Delete Job
            echo "Deleting job $job_id."
            (crontab -l | sed "${job_id}d") | crontab -
            sqlite3 "$DB_FILE" "DELETE FROM jobs WHERE id=$job_id;"
            log "Job $job_id deleted."
            echo "Job deleted successfully."
            ;;
        3)  # Run Job Manually
            echo "Running job $job_id manually."
            log "Manually executing job: $job_name"
            eval "$job_name" >> "$LOG_FILE" 2>&1
            if [[ $? -eq 0 ]]; then
                log "Job $job_id completed successfully."
                echo "Job executed successfully."

                # Update last run status in SQLite
                sqlite3 "$DB_FILE" <<EOF
                UPDATE jobs SET last_run=datetime('now'), status='SUCCESS', message='Manual run successful.' WHERE id=$job_id;
                INSERT INTO job_history (job_id, run_time, status, message) VALUES ($job_id, datetime('now'), 'SUCCESS', 'Manual run successful.');
EOF
            else
                log "Job $job_id failed."
                echo "Job execution failed."
                
                # Update last run status as failure in SQLite
                sqlite3 "$DB_FILE" <<EOF
                UPDATE jobs SET last_run=datetime('now'), status='FAILED', message='Manual run failed.' WHERE id=$job_id;
                INSERT INTO job_history (job_id, run_time, status, message) VALUES ($job_id, datetime('now'), 'FAILED', 'Manual run failed.');
EOF
            fi
            ;;
        4)  # Return to Main Menu
            echo "Returning to main menu."
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}



# Main menu
if [ "$1" ] && [ "$2" ] && [ "$3" ]; then
    schedule_task "$1" "$2" "$3"
else
    while true; do
        echo
        echo "Welcome to the Task Scheduler"
        echo "1) Schedule a new task"
        echo "2) View current jobs"
        echo "3) Run test mode (add, verify, and delete a test job)"
        echo "4) Manually run a scheduled job"
        echo "5) Job Details (view, edit, delete)"
        echo "6) Copy job as one-off"
        echo "7) Exit"
        read -p "Select an option: " option

        case $option in
            1)
                schedule_task
                ;;
            2)
                view_jobs
                ;;
            3)
                test_schedule
                ;;
            4)
                manual_run
                ;;
            5)
                job_details
                ;;
            6)
                copy_job_one_off
                ;;
            7)
                echo "Exiting."
                break
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
    done
fi