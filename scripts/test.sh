#!/bin/bash

#Create 3 example files
cat > ~/programming_project/project_name/examples/ex1.log <<EOF
2026-01-15T10:00:00 SUCCESS setup Environment configured
2026-01-15T10:05:00 SUCCESS alignment Aligned 5000 reads
2026-01-15T10:10:00 WARNING filtering 12 reads below quality threshold
2026-01-15T10:15:00 ERROR variant_call Failed to call variants on chr3
2026-01-15T10:20:00 SUCCESS reporting Report generated
EOF

cat > ~/programming_project/project_name/examples/ex2.txt <<EOF
2026-01-15T10:00:00 SUCCESS initialization System_Ready
2026-01-15T10:05:00 SUCCESS ingestion Loaded_500_records
2026-01-15T10:10:00 SUCCESS processing Transformation_complete
2026-01-15T10:15:00 SUCCESS export Data_sent_to_S3
EOF

cat > ~/programming_project/project_name/examples/ex3.log <<EOF
2026-03-09T20:45:01  INFO    Normal startup sequence initiated.
2026-03-09T20:45:10  ERROR   Connection timeout from server.
                     DEBUG   Retrying connection...
2026-03-09T20:45:12  INFO    Connection re-established.
2026-03-09T20:45:30  WARNING Disk space is low (92% full).
2026-03-09T20:46:00  ERROR   Disk write failed: "Error code 0x5".
CORRUPT LINE - NO DATE
2026-03-09T20:46:05  INFO    Process finished with status: ERROR_OCCURRED
2026-03-09T20:46:10  ERROR   System shutdown.
EOF

# Expected output for example files
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
Error: File must be a .log file.
EOF

cat > ~/programming_project/project_name/examples/ex3_out.txt <<EOF
----------------------------
Log Analysis Report
----------------------------
=== Errors ===
2026-03-09T20:45:10  ERROR   Connection timeout from server.
2026-03-09T20:46:00  ERROR   Disk write failed: "Error code 0x5".
2026-03-09T20:46:10  ERROR   System shutdown.
=== Summary ===
Total Entries: 9
SUCCESS: 0
ERROR: 3
WARNING: 1
First entry: 2026-03-09T20:45:01
Last entry: 2026-03-09T20:46:10
EOF

COMMAND="./scripts/log_analyzer.sh"
EXAMPLE_DIR="./examples"

for input_file in "$EXAMPLE_DIR"/*; do
        if [[ "$input_file" == *"_out.txt" ]]; then
		continue
	fi

	filename=$(basename "$input_file")
	base_name="${filename%.*}"
        expected_out="$EXAMPLE_DIR/${base_name}_out.txt"
	$COMMAND "$input_file" > "tmp_out.txt"
        if cmp -s "tmp_out.txt" "$expected_out"; then
                echo "Pass: $filename output and expected output match."
        else
               	echo "Fail: $filename output and expected output are different."
       	fi
	rm -f "tmp_out.txt"
done

