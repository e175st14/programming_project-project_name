#!/bin/bash

FILE=$1
TIMESTAMP="^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}$"
STATUS=("SUCCESS" "ERROR" "WARNING")

# $TOTAL counts the number of log lines in the log file
TOTAL=$(grep -c "$TIMESTAMP" "$FILE")
# $error_lines captures the entire log line for lines with Error status
error_lines="$TIMESTAMP $STATUS[2] *\n"

# Check if input file exists
if [ ! -f "$FILE" ]; then
	echo "Error: File '$FILE' not found."
	exit 1
fi 

# If the file exists, check if file is in the correct format (.log)
if [[ "$FILE" != *.log ]]; then
        echo "Error: File must be a .log file."
        exit 1
fi 

# If file is a .log file, continue to produce a summary report
if [[ "$FILE" = *.log ]]; then
	echo "----------------------------"
	echo "Log Analysis Report"
	echo "----------------------------"
	echo "=== Errors ==="
	echo "$error_lines"
	echo "=== Summary ==="
	echo "Total Entries: $TOTAL"
	echo "SUCCESS: $(counts[SUCCESS])"
	echo "ERROR: $(counts[ERROR])"
	echo "WARNING: $(counts[WARNING])"
	echo "First entry: $(head -n 1 "$FILE" | awk '{print $TIMESTAMP}')"
	echo "Last entry: $(tail -n 1 "$FILE" | awk '{print $TIMESTAMP}')"
	exit 1 
fi

