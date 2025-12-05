#!/bin/bash
#
# system_health_monitor.sh
# macOS System Health Monitor (CPU, Memory, Disk)
#
# Usage:
#   ./system_health_monitor.sh <CPU_threshold%> <MEM_threshold%> <DISK_threshold%> [interval_seconds]
# Examples:
#   ./system_health_monitor.sh 80 80 90        # monitor with default interval (10s)
#   ./system_health_monitor.sh 75 75 85 5      # monitor every 5 seconds
#
# Exit codes:
#   0 = OK (all metrics below warning thresholds)
#   1 = Warning (one or more metrics >= warning but < critical)
#   2 = Critical (one or more metrics >= critical threshold)
#
# Behavior:
# - If you want the script to run just once and exit, pass interval_seconds as 0.
# - The script uses macOS built-ins: top, vm_stat, sysctl, df, osascript (for notifications).

# ---------------------------
# Helper: colors (ANSI)
# ---------------------------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ---------------------------
# Validate args & defaults
# ---------------------------
if [ $# -lt 3 ]; then
    echo "Usage: $0 <CPU_threshold%> <MEM_threshold%> <DISK_threshold%> [interval_seconds]"
    echo "Example: $0 80 80 90 10"
    exit 1
fi

CPU_THRESH=$1   # e.g., 80 means 80%
MEM_THRESH=$2
DISK_THRESH=$3
INTERVAL=${4:-10}   # default 10 seconds; if 0 => run once and exit

# Convert thresholds to numbers (just in case)
CPU_THRESH=$(printf "%.0f" "$CPU_THRESH")
MEM_THRESH=$(printf "%.0f" "$MEM_THRESH")
DISK_THRESH=$(printf "%.0f" "$DISK_THRESH")

# ---------------------------
# Functions to fetch metrics
# ---------------------------

# Get CPU usage percentage (user + sys) on macOS
get_cpu_usage() {
    # top -l 1 prints one snapshot; look for line "CPU usage: x% user, y% sys, z% idle"
    # We sum user + sys to get used %
    cpu_line=$(top -l 1 -n 0 | awk -F'CPU usage: ' '/CPU usage/ {print $2; exit}')
    # cpu_line example: "3.45% user, 1.23% sys, 95.31% idle"
    user_pct=$(echo "$cpu_line" | awk -F'%, ' '{print $1}' | sed 's/%//g')
    sys_pct=$(echo "$cpu_line" | awk -F'%, ' '{print $2}' | sed 's/%//g' | awk '{print $1}')
    # handle empty case
    user_pct=${user_pct:-0}
    sys_pct=${sys_pct:-0}
    # Use awk for floating math
    used=$(awk -v u="$user_pct" -v s="$sys_pct" 'BEGIN{printf "%.2f", (u + s)}')
    echo "$used"
}

# Get Memory usage percentage on macOS
get_mem_usage() {
    # Approach: Use vm_stat (pages) + sysctl hw.memsize (bytes)
    # vm_stat outputs lines like: "Pages free: 12345."
    page_size=$(vm_stat | head -n1 | awk -F'page size of ' '{print $2}' | awk '{print $1}')
    page_size=${page_size:-4096}   # fallback
    # Extract page counts (numbers may have trailing .)
    free_pages=$(vm_stat | awk '/Pages free/ {gsub("\\.","",$3); print $3}')
    inactive_pages=$(vm_stat | awk '/Pages inactive/ {gsub("\\.","",$3); print $3}')
    speculative_pages=$(vm_stat | awk '/Pages speculative/ {gsub("\\.","",$3); print $3}')
    wired_pages=$(vm_stat | awk '/Pages wired down/ {gsub("\\.","",$4); print $4}')
    # Some macOS versions write "Pages wired down:" or "Pages wired down" with different positions; fallback attempts:
    if [ -z "$wired_pages" ]; then
        wired_pages=$(vm_stat | awk '/Pages wired/ {gsub("\\.","",$3); print $3}')
    fi

    free_pages=${free_pages:-0}
    inactive_pages=${inactive_pages:-0}
    speculative_pages=${speculative_pages:-0}
    wired_pages=${wired_pages:-0}

    total_bytes=$(sysctl -n hw.memsize)
    # Convert pages to bytes
    free_bytes=$(awk -v p="$free_pages" -v s="$page_size" 'BEGIN{printf "%.0f", p*s}')
    # Consider used = total - free (this is simpler & robust)
    used_bytes=$(awk -v t="$total_bytes" -v f="$free_bytes" 'BEGIN{printf "%.0f", t - f}')
    # compute percentage
    used_pct=$(awk -v u="$used_bytes" -v t="$total_bytes" 'BEGIN{ if(t>0){printf "%.2f", (u/t)*100}else{print "0.00"}}')
    echo "$used_pct"
}

# Get Disk usage percentage for root (/) or mount
get_disk_usage() {
    # df -k / will show usage for root. Field 5 is Use% with a '%' sign
    # Use awk to strip the % sign
    usage=$(df -k / | tail -1 | awk '{print $5}' | sed 's/%//g')
    usage=${usage:-0}
    echo "$usage"
}

# Send macOS notification (osascript)
send_notification() {
    title="$1"
    message="$2"
    # using osascript to display a user notification on macOS
    osascript -e "display notification \"${message}\" with title \"${title}\""
}

# Colorize and print status
print_status() {
    name="$1"
    value="$2"
    warn="$3"
    crit="$4"

    status_color=$GREEN
    status_text="OK"

    # value may be float; compare using awk
    is_crit=$(awk -v v="$value" -v c="$crit" 'BEGIN{print (v >= c) ? 1 : 0}')
    is_warn=$(awk -v v="$value" -v w="$warn" 'BEGIN{print (v >= w && v < '"$crit"') ? 1 : 0}')

    if [ "$is_crit" -eq 1 ]; then
        status_color=$RED
        status_text="CRITICAL"
    elif [ "$is_warn" -eq 1 ]; then
        status_color=$YELLOW
        status_text="WARNING"
    else
        status_color=$GREEN
        status_text="OK"
    fi

    printf "%s%-10s%s : %6s%%  Status: %s%s%s\n" "$NC" "$name" "$NC" "$value" "$status_color" "$status_text" "$NC"
}

# Evaluate single snapshot and return highest exit code (0=OK,1=Warn,2=Crit)
evaluate_once() {
    cpu_val=$(get_cpu_usage)         # float like 12.34
    mem_val=$(get_mem_usage)         # float like 45.67
    disk_val=$(get_disk_usage)       # integer like 70

    # For comparisons, use awk to check >= thresholds
    cpu_crit=$(awk -v v="$cpu_val" -v t="$CPU_THRESH" 'BEGIN{print (v >= t) ? 1 : 0}')
    mem_crit=$(awk -v v="$mem_val" -v t="$MEM_THRESH" 'BEGIN{print (v >= t) ? 1 : 0}')
    disk_crit=$(awk -v v="$disk_val" -v t="$DISK_THRESH" 'BEGIN{print (v >= t) ? 1 : 0}')

    # Determine highest severity among metrics for exit code.
    exit_code=0
    if [ "$cpu_crit" -eq 1 ] || [ "$mem_crit" -eq 1 ] || [ "$disk_crit" -eq 1 ]; then
        exit_code=2
    fi

    # Print colored statuses
    print_status "CPU" "$cpu_val" "$((CPU_THRESH - 10))" "$CPU_THRESH"
    print_status "MEM" "$mem_val" "$((MEM_THRESH - 10))" "$MEM_THRESH"
    print_status "DISK" "$disk_val" "$((DISK_THRESH - 10))" "$DISK_THRESH"

    # Send notification if any metric >= threshold
    if [ "$exit_code" -eq 2 ]; then
        send_notification "System HEALTH CRITICAL" "CPU:${cpu_val}% MEM:${mem_val}% DISK:${disk_val}%"
    fi

    return $exit_code
}

# ---------------------------
# Main monitoring loop
# ---------------------------
echo "Starting macOS system health monitor"
echo "Thresholds => CPU: ${CPU_THRESH}%  MEM: ${MEM_THRESH}%  DISK: ${DISK_THRESH}%"
echo "Interval: ${INTERVAL}s (set to 0 to run once and exit)"
echo "Press Ctrl+C to stop."

# If interval == 0, run once and exit
if [ "$INTERVAL" -eq 0 ]; then
    evaluate_once
    exit $?
fi

# Continuous monitoring
while true; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "----------------------------------------"
    echo "Timestamp: $timestamp"
    evaluate_once
    rc=$?
    # If critical, keep monitoring but also print red banner
    if [ "$rc" -eq 2 ]; then
        echo -e "${RED}CRITICAL threshold reached. Notification sent.${NC}"
    fi
    # Sleep for given interval
    sleep "$INTERVAL"
done
