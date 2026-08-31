#!/bin/bash

# ─────────────────────────────────────────
#  System Information Script
# ─────────────────────────────────────────

echo "======================================"
echo "       SYSTEM INFORMATION REPORT"
echo "======================================"

# 1. Current date
current_date=$(date)
echo "Date     : $current_date"

# 2. Hostname
current_host=$(hostname)
echo "Hostname : $current_host"

# 3. Username
current_user=$(whoami)
echo "User     : $current_user"

echo ""
echo "--- Disk Usage ---"
# 4. Disk usage
df -h

echo ""
echo "--- Running Processes ---"
# 5. Running processes
ps aux

# 6. Take user input
echo ""
echo "======================================"
read -p "Enter your name       : " name
read -p "Enter your roll number: " roll_no
read -p "Enter a comment       : " comment

echo ""
echo "Hello $name! Your roll number is $roll_no."
echo "Your comment: $comment"

# 7. Create a directory and a file inside it
output_dir="system_report_${name}"
mkdir -p "$output_dir"
output_file="$output_dir/process.log"
touch "$output_file"

# 8. Store running processes in the file using > redirection
ps aux > "$output_file"

echo ""
echo "======================================"
echo "Report saved!"
echo "Directory : $output_dir"
echo "File      : $output_file"
echo "======================================"
