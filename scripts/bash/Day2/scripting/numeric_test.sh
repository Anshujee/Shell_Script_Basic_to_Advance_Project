#!/bin/bash

# Comparision Operators :
# -eq : equal to
# -ne : not equal to
# -gt : greater than
# -lt : less than
# -ge : greater than or equal to
# -le : less than or equal to

CPU_USAGE=75
MEMORY_USAGE=60
DISK_USAGE=80

echo " == System Resource Check =="
echo " CPU Usage: $CPU_USAGE%"
echo " Memory Usage: $MEMORY_USAGE%"
echo " Disk Usage: $DISK_USAGE%"
echo""

# Check CPU Usage
if [ $CPU_USAGE -gt 80 ]; then
    echo " Warning: High CPU usage detected!"
elif [ $CPU_USAGE -gt 60 ]; then
    echo " Alert: Moderate CPU usage."
else
    echo " CPU usage is within normal limits."
fi
echo ""
# Check Memory Usage
if [ $MEMORY_USAGE -gt 80 ]; then
    echo " Warning: High Memory usage detected!"
elif [ $MEMORY_USAGE -gt 60 ]; then
    echo " Alert: Moderate Memory usage."
else
    echo " Memory usage is within normal limits."
fi
echo ""
# Check Disk Usage
if [ $DISK_USAGE -gt 80 ]; then
    echo " Warning: High Disk usage detected!"
elif [ $DISK_USAGE -gt 60 ]; then
    echo " Alert: Moderate Disk usage."
else
    echo " Disk usage is within normal limits."
fi
echo ""
# Overall System Health Check
if [ $CPU_USAGE -le 60 ] && [ $MEMORY_USAGE -le 60 ] && [ $DISK_USAGE -le 60 ]; then
    echo " System Health: Good"
elif [ $CPU_USAGE -le 80 ] && [ $MEMORY_USAGE -le 80 ] && [ $DISK_USAGE -le 80 ]; then
    echo " System Health: Moderate"
else
    echo " System Health: Poor"
fi

