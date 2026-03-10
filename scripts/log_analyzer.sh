#!/bin/bash

# Check if first argument exists
if [ -z "$FILE" ]; then
        echo "Usage: $0 <file>."
        exit 1
fi

FILE=$1

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

# $TIMESTAMP captures timestamps in the log file
TIMESTAMP=$(grep -Eo $'[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}' "$FILE")

# $TOTAL counts the number of log lines in the log file
TOTAL=$(awk 'END{print NR}' "$FILE")

# $error_lines captures the entire log line for lines with Error status
error_lines=$(awk '$2=="ERROR"' "$FILE" | awk '{print}')

# If file is a .log file, continue to produce a summary report
if [[ "$FILE" = *.log ]]; then
	echo "----------------------------"
	echo "Log Analysis Report"
	echo "----------------------------"
	echo "=== Errors ==="
	echo "$error_lines"
	echo "=== Summary ==="
	echo "Total Entries: $TOTAL"
	echo "SUCCESS: $(grep -c "SUCCESS" "$FILE")"
	echo "ERROR: $(grep -c "ERROR" "$FILE")"
	echo "WARNING: $(grep -c "WARNING" "$FILE")"
	echo "First entry: $(grep -Eo $'[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}' "$FILE" | head -n 1)"
	echo "Last entry: $(grep -Eo $'[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}' "$FILE" | tail -n 1)"
	exit 1
fi

