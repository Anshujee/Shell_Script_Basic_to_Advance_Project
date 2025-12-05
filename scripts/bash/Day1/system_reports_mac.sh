#!/bin/bash

echo "Generating system report..."
echo " ===================================="
echo " System Report - $(date) "
echo " ===================================="

REPORT_FILE="system_report_$(date +%Y%m%d_%H%M%S).txt"

{
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime)"
    echo "------------------------------------"

    echo "CPU Information:"
    # macOS equivalent of lscpu
    sysctl -n machdep.cpu.brand_string
    echo "CPU Cores: $(sysctl -n hw.ncpu)"
    echo "------------------------------------"

    echo "Memory Usage:"
    # macOS does not have free -h, use vm_stat conversion
    mem_total=$(sysctl -n hw.memsize)
    mem_free=$(vm_stat | awk '/free/ {print $3}' | sed 's/\.//')
    page_size=$(vm_stat | head -n1 | awk '{print $8}')
    free_mem_mb=$((mem_free * page_size / 1024 / 1024))
    total_mem_mb=$((mem_total / 1024 / 1024))

    echo "Total Memory: ${total_mem_mb} MB"
    echo "Free Memory : ${free_mem_mb} MB"
    echo "------------------------------------"

    echo "Disk Usage:"
    df -h
    echo "------------------------------------"

    echo "Top 5 Memory Consuming Processes:"
    # macOS doesn't support ps aux --sort, so we sort manually
    ps aux | sort -nrk 4 | head -n 6
    echo "------------------------------------"

    echo "Network Configuration:"
    # macOS equivalent of ip addr show
    ifconfig
    echo "------------------------------------"

    echo "Listening Ports:"
    # macOS equivalent of ss -tuln
    netstat -an | grep LISTEN
    echo "------------------------------------"

    echo "Recent System Logs (last 10 lines):"
    # macOS does NOT have /var/log/syslog
    # Instead: system.log
    if [ -f /var/log/system.log ]; then
        tail -n 10 /var/log/system.log
    else
        echo "system.log not found on macOS"
    fi

} > "$REPORT_FILE"

echo "System report generated: $REPORT_FILE"
echo "Report saved to $REPORT_FILE"
echo "Done."
