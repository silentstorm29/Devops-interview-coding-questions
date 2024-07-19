#!/bin/bash

# Define the log file path
log_file="/path/to/your/logfile.log"

# Check if the log file exists
if [ -f "$log_file" ]; then
  # Display the last 10 lines of the log file
  tail -n 10 "$log_file"
else
  echo "Log file not found!"
fi
