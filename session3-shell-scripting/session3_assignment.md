# Session 3 - Shell Scripting Assignment

## Task: System Information Script

A shell script (`system_info.sh`) that collects system information, takes user input, creates a directory and file, and stores running processes in that file.

---

## Concepts Used

| Concept | Used For |
|---|---|
| Variables | Storing date, hostname, username, user input |
| `echo` | Printing output to terminal |
| `date` | Getting current date and time |
| `hostname` | Getting the machine's hostname |
| `whoami` | Getting the current logged-in user |
| `df -h` | Showing disk usage in human-readable format |
| `ps aux` | Listing all running processes |
| `read -p` | Taking interactive input from the user |
| `mkdir -p` | Creating a directory (no error if already exists) |
| `touch` | Creating an empty file |
| `>` | Output redirection — writing command output to a file |

---

## How to Run

```bash
# Make it executable (first time only)
chmod +x system_info.sh

# Run the script
./system_info.sh
```

---

## Script Walkthrough

```bash
#!/bin/bash

# Variables storing system info using command substitution $()
current_date=$(date)
current_host=$(hostname)
current_user=$(whoami)

echo "Date     : $current_date"
echo "Hostname : $current_host"
echo "User     : $current_user"

# Disk usage
df -h

# Running processes
ps aux

# Taking user input
read -p "Enter your name       : " name
read -p "Enter your roll number: " roll_no
read -p "Enter a comment       : " comment

# Creating a directory named after the user
mkdir -p "system_report_${name}"

# Creating a file inside it
touch "system_report_${name}/process.log"

# Storing running processes into the file using > redirection
ps aux > "system_report_${name}/process.log"
```

---

## Sample Output

```
======================================
       SYSTEM INFORMATION REPORT
======================================
Date     : Sun Aug 31 14:32:10 IST 2025
Hostname : sanaa-macbook
User     : sanaaara

--- Disk Usage ---
Filesystem       Size   Used  Avail Capacity  Mounted on
/dev/disk3s1s1  460Gi  213Gi  180Gi    55%   /
devfs           206Ki  206Ki    0Bi   100%   /dev
/dev/disk3s6    460Gi   20Ki  180Gi     1%   /System/Volumes/VM

--- Running Processes ---
USER   PID  %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
root     1   0.0  0.0 410423680   8064   ??  Ss   Fri09AM   0:24.47 /sbin/launchd
...

======================================
Enter your name       : Sanaa
Enter your roll number: 42
Enter a comment       : DevOps is fun!

Hello Sanaa! Your roll number is 42.
Your comment: DevOps is fun!

======================================
Report saved!
Directory : system_report_Sanaa
File      : system_report_Sanaa/process.log
======================================
```

---

## Key Concepts Explained

### Variables
```bash
name="Sanaa"          # assign
echo $name            # use
current_date=$(date)  # command substitution — store output of a command
```

### `read -p`
```bash
read -p "Enter your name: " name
# -p lets you show a prompt message on the same line
# input is stored in the variable 'name'
```

### `mkdir -p`
```bash
mkdir -p system_report_Sanaa
# -p means: create parent directories if needed, and don't error if it already exists
```

### `>` Output Redirection
```bash
ps aux > process.log
# Takes all output from ps aux and writes it INTO process.log
# Overwrites the file if it already exists
# Use >> to append instead of overwrite
```
