#!/usr/bin/env bash

GENERATED_AT=$(date '+%Y-%m-%d %H:%M:%S %Z')
UPTIME_TEXT=$(uptime -p)
DISK_USAGE=$(df -P / | awk 'NR == 2 {print $5}')
DISK_PERCENT=${DISK_USAGE%\%}
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')

check_disk_status() {
    if [ "$1" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}


DISK_STATUS=$(check_disk_status "$DISK_PERCENT")

OUTPUT_DIR="/var/www/html/viikko3"
OUTPUT_FILE="$OUTPUT_DIR/index.html"

sudo mkdir -p "$OUTPUT_DIR"

sudo tee "$OUTPUT_FILE" > /dev/null <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Week 3 - Server Status Report</title>
</head>
<body>

    <h1>Server Status Report</h1>

    <p><strong>Report generated:</strong> $GENERATED_AT</p>
    <p><strong>Server uptime:</strong> $UPTIME_TEXT</p>
    <p><strong>Root filesystem disk usage:</strong> $DISK_USAGE</p>
    <p><strong>Disk space status:</strong> $DISK_STATUS</p>
    <p><strong>Total RAM:</strong> $MEM_TOTAL MiB</p>
    <p><strong>Available RAM:</strong> $MEM_AVAILABLE MiB</p>

</body>
</html>
EOF

echo "HTML report generated: $OUTPUT_FILE"
