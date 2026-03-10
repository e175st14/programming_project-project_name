Log File Analyzer

This scripts allows you to quickly analyze log files in bash and produces a summary report, which helps track the parts of a script 
that cause slowdowns or errors, and helps identify areas where a script can be improved. 

In order to use this script, the first argument in the command line would be the path to access the log_analyzer.sh file. 
The second argument would be the path to the log file you wish to analyze. 

Ex: (If in directory ~/programming_project/project_name) 

./scripts/log_analyzer.sh ./examples/ex1.log
OR
./scripts/log_analyzer.sh ../data/pipeline.log
OR
~/programming_project/project_name/scripts/log_analyzer.sh ~/programming_project/data/pipeline.log

The format of input files should be log files, otherwise the script will be unable to analyze the file. A log file contains any number of lines, 
each starting with a timestamp of comprehensive date and time information, a status (success, error, or warning), and a step message. 

Example Input:
2026-01-15T10:00:00 SUCCESS setup Environment configured
2026-01-15T10:05:00 SUCCESS alignment Aligned 5000 reads
2026-01-15T10:10:00 WARNING filtering 12 reads below quality threshold
2026-01-15T10:15:00 ERROR variant_call Failed to call variants on chr3
2026-01-15T10:20:00 SUCCESS reporting Report generated


The output of the log_analyzer.sh script starts with the title, "Log Analysis Report," and then lists the complete lines of all error messages in 
the log file. Then, there will be a "Summary Report," listing the total number of entries in the log file, the number of successes, 
number of errors, number of warnings, and the timestamp of the first entry, and the timestamp of the last entry. 

Example Output:
----------------------------
Log Analysis Report
----------------------------
=== Errors ===
2026-01-15T10:15:00 ERROR variant_call Failed to call variants on chr3
=== Summary ===
Total Entries: 5
SUCCESS: 3
ERROR: 1
WARNING: 1
First entry: 2026-01-15T10:00:00
Last entry: 2026-01-15T10:20:00

