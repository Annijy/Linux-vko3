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
TEMP_FILE="$OUTPUT_DIR/index.tmp"

mkdir -p "$OUTPUT_DIR"

cat > "$TEMP_FILE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Week 3 - Server Status Report</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 40px 20px;
            font-family: Arial, Helvetica, sans-serif;
            background: #111827;
            color: #111;
        }

        .container {
            max-width: 950px;
            margin: 0 auto;
        }

        h1 {
            color: white;
            font-size: 46px;
            margin-bottom: 8px;
        }

        .intro {
            color: #cbd5e1;
            font-size: 18px;
            margin-bottom: 30px;
        }

        .status-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 18px;
            margin-bottom: 28px;
        }

        .card {
            padding: 22px;
            border: 4px solid white;
            box-shadow: 7px 7px 0 black;
            border-radius: 14px;
        }

        .card:nth-child(1) {
            background: #fde047;
        }

        .card:nth-child(2) {
            background: #67e8f9;
        }

        .card:nth-child(3) {
            background: #86efac;
        }

        .card:nth-child(4) {
            background: #f9a8d4;
        }

        .card:nth-child(5) {
            background: #c4b5fd;
        }

        .card:nth-child(6) {
            background: #fdba74;
        }

        .label {
            font-size: 13px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .value {
            font-size: 28px;
            font-weight: bold;
            margin-top: 8px;
        }

        section {
            background: white;
            border-radius: 14px;
            padding: 26px;
            margin-bottom: 22px;
        }

        h2 {
            margin-top: 0;
        }

        code {
            background: transparent;
            padding: 0;
            border-radius: 0;
            font-family: Arial, Helvetica, sans-serif;
            color: #555;
        }

        .test-result {
            font-size: 18px;
            line-height: 1.8;
        }

        a {
            color: #2563eb;
            font-weight: bold;
        }

        footer {
            color: #94a3b8;
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>

<body>
<div class="container">

    <h1>Week 3: Server Status Report</h1>

    <p class="intro">
        This page is made automatically by my Bash script every minute.
    </p>

    <div class="status-grid">

        <div class="card">
            <div class="label">Report generated</div>
            <div class="value">$GENERATED_AT</div>
        </div>

        <div class="card">
            <div class="label">Server uptime</div>
            <div class="value">$UPTIME_TEXT</div>
        </div>

        <div class="card">
            <div class="label">Root disk usage</div>
            <div class="value">$DISK_USAGE</div>
        </div>

        <div class="card">
            <div class="label">Disk space status</div>
            <div class="value">$DISK_STATUS</div>
        </div>

        <div class="card">
            <div class="label">Total RAM</div>
            <div class="value">$MEM_TOTAL MiB</div>
        </div>

        <div class="card">
            <div class="label">Available RAM</div>
            <div class="value">$MEM_AVAILABLE MiB</div>
        </div>

    </div>

    <section>
        <h2>How the script works</h2>

        <p>
            This Bash script gets information from my server.
            The information is saved in variables.
        </p>

        <p>
            The script checks how much disk space is used.
            If disk usage is under 80%, the status is OK.
            If disk usage is 80% or more, the status is WARNING.
        </p>

        <p>
            The script makes an HTML file.
            Nginx shows the file on my website.
        </p>
    </section>

    <section>
        <h2>Commands used</h2>

        <p>
            <code>date '+%Y-%m-%d %H:%M:%S %Z'</code><br>
            This shows the date, time and time zone.
        </p>

        <p>
            <code>uptime -p</code><br>
            This shows how long the server has been running.
        </p>

        <p>
            <code>df -P / | awk 'NR == 2 {print \$5}'</code><br>
            This checks disk usage.
            The pipe sends the result from df to awk.
            Awk takes the disk usage percentage.
        </p>

        <p>
            <code>free -m</code><br>
            This shows the server memory.
        </p>
    </section>

    <section>
        <h2>Automatic updates</h2>

        <p>
            Cron runs my script every minute.
        </p>

        <p>
            The schedule is:
        </p>

        <p>
            <code>* * * * * /home/ubuntu/viikko3/report.sh</code>
        </p>

        <p>
            I restarted the server and cron still worked.
        </p>
    </section>

    <section>
        <h2>Test results</h2>

        <h3>Disk space test</h3>

        <p>
            I tested three different values.
        </p>

        <div class="test-result">
            50% &rarr; OK &rarr; Test passed<br>
            80% &rarr; WARNING &rarr; Test passed<br>
            90% &rarr; WARNING &rarr; Test passed
        </div>

        <h3>Syntax and manual test</h3>

        <p>
            I checked the script with bash -n.
            There were no errors.
            I also started the script myself and the HTML page worked.
        </p>

        <h3>Automatic update test</h3>

        <p>
            I checked two automatic updates:<br>
    2026-11-11 15:56:01 UTC<br>
    2026-11-11 15:57:01 UTC<br>
    The report updated automatically after one minute.
        </p>

        <h3>Reboot test</h3>

        <p>
            I restarted the server.
            Week 2 and Week 3 pages still worked after restart.
            The Week 3 page also continued updating.
        </p>
    </section>

    <section>
        <h2>One thing I learned</h2>

        <p>
            I learned how to use a pipe and awk.
            I also learned how cron can run my script automatically.
        </p>
    </section>

    <section>
        <h2>Source code</h2>

        <p>
            <a href="https://github.com/Annijy/Linux-vko3" target="_blank">
                My Week 3 project on GitHub
            </a>
        </p>

        <p>
            <a href="/viikko2/">
                Week 2 application
            </a>
        </p>
    </section>

    <footer>
        Linux course - Week 3 - Bash server status report
    </footer>

</div>
</body>
</html>
EOF

mv "$TEMP_FILE" "$OUTPUT_FILE"

echo "HTML report generated: $OUTPUT_FILE"
