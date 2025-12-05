# Want to create a comprehensive system report in bash? 
# Here's a script that gathers various system information and outputs it to a file.

#!/bin/bash
echo "Generating system report..."
echo " ===================================="
echo " System Report - $(date) "
echo " ===================================="

REPORT_FILE="system_report_$(date +%Y%m%d_%H%M%S).txt"

{
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "------------------------------------"
    echo "CPU Information:"
    # lscpu
    # Write a command in MAC OS which is equivalaent to lscpu
    sysctl -n machdep.cpu.brand_string
    echo "------------------------------------"
    echo "Memory Usage:"
    # free -h
    # Write a command in MAC OS which is equivalaent to free -h
    vm_stat | awk 'NR==1{print "Total Memory: " $3*4096/1024/1024 " MB"} NR==2{print "Free Memory: " $3*4096/1024/1024 " MB"} NR==3{print "Active Memory: " $3*4096/1024/1024 " MB"} NR==4{print "Inactive Memory: " $3*4096/1024/1024 " MB"} NR==5{print "Wired Memory: " $3*4096/1024/1024 " MB"}'
    echo "------------------------------------"
    echo "Disk Usage:"
    df -h
    echo "------------------------------------"
    echo "Top 5 Memory Consuming Processes:"
    # ps aux --sort=-%mem | head -n 6
    # Write a command in MAC OS which is equivalaent to ps aux --sort=-%mem | head -n 6
    ps aux | sort -nrk 4 | head -n 6
    echo "------------------------------------"
    echo "Network Configuration:"
    # ip addr show for Linux systems
    # Write a command in MAC OS which is equivalaent to ip addr show
    ifconfig # MAC OS equivalent
    echo "------------------------------------"

    echo "Listening Ports:"
    # ss -tuln for Linux systems
    # Write a command in MAC OS which is equivalaent to ss -tuln
    netstat -an | grep LISTEN # MAC OS equivalent
    echo "------------------------------------"
    echo "Recent System Logs (last 10 lines):"
    tail -n 10 /var/log/syslog
} > "$REPORT_FILE"
echo "System report generated: $REPORT_FILE"
echo "Report saved to $REPORT_FILE"
echo "Done."