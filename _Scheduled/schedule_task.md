# Task Scheduler Script - `schedule_task.sh`

A versatile Bash script to help you schedule, view, edit, and manage tasks on macOS using `cron`. It supports creating both one-off and recurring tasks with options to view, manually execute, edit, and delete scheduled jobs.

### Features
- Schedule one-off or recurring tasks
- View all scheduled tasks in a readable format
- Edit or delete tasks by job number
- Manually execute scheduled jobs immediately
- Optional command-line parameters for quick job creation

---

## Prerequisites
- macOS with `cron` enabled (default on macOS)
- Ensure that `/usr/bin/python3` and `curl` are available if running Python or making web requests.

---

## Setup

1. **Clone or download the script**.
2. **Make the script executable**:
   ```bash
   chmod +x schedule_task.sh
   ```

---

## Usage

### 1. Running the Script
To start the interactive menu, run:

```bash
./schedule_task.sh
```

### 2. Command-Line Parameters (Direct Job Creation)

To skip the interactive menu and directly create a job, pass in:
- **Path to the script**: Full path to the executable/script
- **Job name**: A descriptive name for the job
- **Cron schedule**: Cron syntax for timing (e.g., `* * * * *` for every minute)

Example:

```bash
./schedule_task.sh "/path/to/script.sh" "My Recurring Task" "0 9 * * 1"
```

The example above schedules the script to run every Monday at 9 AM.

---

## Menu Options

If you run `schedule_task.sh` without parameters, an interactive menu is presented:

### 1) **Schedule a New Task**

   - **Executable Path**: Provide the full path to the executable/script.
   - **Job Name**: Enter a name for easy identification.
   - **Task Type**:
     - **One-off**: Specify the date and time (in Central Time).
     - **Recurring**: Choose from daily, weekly, or monthly, and set the time and recurrence pattern.
   - The script will confirm and log each task created.

### 2) **View Current Jobs**
   - Lists all scheduled jobs with their cron syntax and command.
   - Output is shown both in the terminal and logged to `scheduler.log`.

### 3) **Run Test Mode**
   - Adds a temporary job to `cron`, waits 10 seconds for execution, verifies its success, and deletes the job.
   - Useful for testing cron job functionality.

### 4) **Manually Run a Scheduled Job**
   - Lists all scheduled jobs by job number.
   - Select a job to execute immediately.

### 5) **Job Details (View, Edit, Delete)**
   - Lists scheduled jobs with their details.
   - Options:
     - **Edit**: Modify the cron schedule and/or command.
     - **Delete**: Remove a job.
   - Uses job number for selection, with descriptions to help identify each job.

### 6) **Exit**
   - Closes the script.

---

## Logs

Each action taken by the script is logged to `scheduler.log` for reference and troubleshooting. 

---

## Examples

### Schedule a New Job Interactively

1. Run the script:
   ```bash
   ./schedule_task.sh
   ```
2. Select **1** to schedule a new task.
3. Follow prompts to specify the script path, job name, and schedule details.

### Manually Run a Job

1. Run the script and select **4**.
2. Choose the job number you want to run immediately.

### Quick Job Creation with Command-Line Arguments

To schedule a job to run every day at midnight:

```bash
./schedule_task.sh "/path/to/script.sh" "Daily Midnight Task" "0 0 * * *"
```

---

## Notes

- **Timezone**: All times entered are in Central Time (`America/Chicago`).
- **Script Validity**: Ensure scripts provided are executable (`chmod +x your_script.sh`).
- **Error Handling**: The script checks paths and permissions; incorrect entries prompt for re-entry.
