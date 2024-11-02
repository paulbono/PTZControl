#!/bin/bash

# File: schedule_task.sh
# Schedule tasks with options for one-off or recurring jobs on macOS using cron.

LOG_FILE="/Users/av/git/PTZControl/_Scheduled/scheduler.log"
TIMEZONE="America/Chicago"  # Central Time

# Logging function
log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
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

# View current cron jobs
view_jobs() {
    echo "Current cron jobs for $(whoami):"
    crontab -l | tee -a "$LOG_FILE"
}

# Manually trigger a job execution
manual_run() {
    echo "Available jobs:"
    crontab -l | grep "#" | awk -F'#' '{print $2}' | nl
    read -p "Enter the job number to run manually: " job_number

    # Extract the command portion only, excluding the cron timing
    job_command=$(crontab -l | grep "#" | awk -F'#' '{print $1}' | awk '{$1=$2=$3=$4=$5=""; print $0}' | sed 's/^ *//g' | sed -n "${job_number}p")

    if [[ -z "$job_command" ]]; then
        echo "Invalid job number."
    else
        log "Manually executing job: $job_command"
        echo "Running job..."
        eval "$job_command"
        log "Job executed."
    fi
}

# Details for viewing, editing, and deleting jobs
job_details() {
    echo "Current jobs:"
    crontab -l | grep "#" | nl

    read -p "Enter job number to view details, edit, or delete: " job_number
    job_entry=$(crontab -l | grep "#" | sed -n "${job_number}p")

    if [[ -z "$job_entry" ]]; then
        echo "Invalid job number."
        return
    fi

    cron_expression=$(echo "$job_entry" | awk '{print $1, $2, $3, $4, $5}')
    job_command=$(echo "$job_entry" | awk '{$1=$2=$3=$4=$5=""; print $0}' | sed 's/^ *//')

    echo "Details for job $job_number:"
    cron_to_human "$cron_expression"
    echo "Command: $job_command"

    echo "Options:"
    echo "1) Edit job"
    echo "2) Delete job"
    echo "3) Back to main menu"
    read -p "Choose an option: " choice

    case $choice in
        1)
            echo "Editing job $job_number."
            read -p "Enter new cron timing (e.g., '* * * * *'): " new_cron
            read -p "Enter new command (or press enter to keep current): " new_command
            new_command="${new_command:-$job_command}"

            updated_entry="$new_cron $new_command"
            (crontab -l | sed "${job_number}s@.*@$updated_entry@") | crontab -
            log "Job $job_number updated to: $updated_entry"
            echo "Job updated successfully."
            ;;
        2)
            echo "Deleting job $job_number."
            (crontab -l | sed "${job_number}d") | crontab -
            log "Job $job_number deleted."
            echo "Job deleted successfully."
            ;;
        3)
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
        echo "6) Exit"
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
                echo "Exiting."
                break
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
    done
fi
