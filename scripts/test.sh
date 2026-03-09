#!/bin/bash

#Create 3 example log files
cat > ~/programming_project/project_name/examples/ex1.log <<EOF
2026-01-15T10:00:00 SUCCESS setup Environment configured
2026-01-15T10:05:00 SUCCESS alignment Aligned 5000 reads
2026-01-15T10:10:00 WARNING filtering 12 reads below quality threshold
2026-01-15T10:15:00 ERROR variant_call Failed to call variants on chr3
2026-01-15T10:20:00 SUCCESS reporting Report generated
EOF

cat > ~/programming_project/project_name/examples/ex2.log <<EOF
2026-01-15T10:00:00 SUCCESS initialization System_Ready
2026-01-15T10:05:00 SUCCESS ingestion Loaded_500_records
2026-01-15T10:10:00 SUCCESS processing Transformation_complete
2026-01-15T10:15:00 SUCCESS export Data_sent_to_S3
EOF

cat > ~/programming_project/project_name/examples/ex3.log <<EOF
2026-01-15T11:00:00 SUCCESS initialization System_Ready
2026-01-15T11:02:30 WARNING ingestion Low_memory_detected
2026-01-15T11:05:00 ERROR processing Database_connection_lost
2026-01-15T11:10:00 ERROR processing Retry_failed_after_3_attempts
2026-01-15T11:15:00 WARNING cleanup Temp_files_not_deleted
EOF

# Expected output for example log files
cat > ~/programming_project/project_name/examples/ex1_out.txt <<EOF
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
EOF

cat > ~/programming_project/project_name/examples/ex2_out.txt <<EOF
----------------------------
Log Analysis Report
----------------------------
=== Errors ===

=== Summary ===
Total Entries: 4
SUCCESS: 4
ERROR: 0
WARNING: 0
First entry: 2026-01-15T10:00:00
Last entry: 2026-01-15T10:15:00
EOF

cat > ~/programming_project/project_name/examples/ex3_out.txt <<EOF
----------------------------
Log Analysis Report
----------------------------
=== Errors ===
2026-01-15T11:05:00 ERROR processing Database_connection_lost
2026-01-15T11:10:00 ERROR processing Retry_failed_after_3_attempts
=== Summary ===
Total Entries: 5
SUCCESS: 1
ERROR: 2
WARNING: 2
First entry: 2026-01-15T11:00:00
Last entry: 2026-01-15T11:15:00
EOF

COMMAND="./scripts/log_analyzer.sh"
EXAMPLE_DIR="./examples"

for input_file in "$EXAMPLE_DIR"/*.log; do
        base_name=$(basename "$input_file" .log)
        expected_out="$EXAMPLE_DIR/${base_name}_out.txt"
        $COMMAND "$input_file" > "tmp_out.txt"
        if cmp -s "tmp_out.txt" "$expected_out"; then
                echo "Pass: test output and expected output match."
        else
                echo "Fail: test output and expected output are different."
        fi
	rm -f "tmp_out.txt"
done

