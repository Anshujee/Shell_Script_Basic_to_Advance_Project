# Some Important Shell Command used Day to Day life
1. Understanding Your Location
bash
# Where am I right now?
pwd
# What's in this directory?
ls
# Show hidden files too
ls -a
# Show detailed info (permissions, size, date)
ls -l
# Combine options for detailed view with hidden files
ls -la
# Human readable file sizes
ls -lh

2. Directory Navigation
# Go to home directory
cd ~
pwd
# Go to root directory
cd /
pwd
ls
# Go back to previous directory
cd -
# Go up one level
cd ..
pwd
# Go up two levels
cd ../..
pwd
# Go to a specific path
cd /var/log
ls -l
# Return home
cd

3. Create Your DevOps Project Structure
# Start in home directory
cd ~
# Create main project directory
mkdir devops-projects
# Navigate into it
cd devops-projects
# Create multiple directories at once
mkdir -p scripts/{bash,python,monitoring}
mkdir -p configs/{nginx,docker,kubernetes}
mkdir -p logs/{app,system,security}
mkdir -p docs/{runbooks,architecture,guides}
# Verify structure
tree
# If tree not installed: sudo apt install tree -y
# Alternative to view structure
ls -R

Part A File Operations - Create, Copy, Move, Delete
# Navigate to scripts directory
cd ~/devops-projects/scripts/bash
# Create empty file - Method 1
touch deployment.sh
# Create empty file - Method 2
> backup.sh
# Create file with content
echo "#!/bin/bash" > health_check.sh
# Append to file (doesn't overwrite)
echo "echo 'System Health Check'" >> health_check.sh
echo "date" >> health_check.sh
# View file content
cat health_check.sh
# Create multiple files at once
touch script1.sh script2.sh script3.sh
# List all files
ls -l

Part B Copying Files
# Copy single file
cp health_check.sh health_check_backup.sh
# Copy to different directory
cp health_check.sh ~/devops-projects/scripts/
# Copy entire directory
cp -r ~/devops-projects/scripts ~/devops-projects/scripts-backup
# Copy with verbose output (see what's being copied)
cp -v health_check.sh ../python/
# Copy and preserve permissions/timestamps
cp -p health_check.sh health_check_v2.sh

Part C: Moving/Renaming Files
# Rename file
mv script1.sh startup_script.sh
# Move file to another directory
mv script2.sh ../monitoring/
# Move multiple files
mv script3.sh deployment.sh ~/devops-projects/logs/
# Move and rename at same time
mv backup.sh ~/devops-projects/scripts/monitoring/system_backup.sh

Part D: Deleting Files (BE CAREFUL!)
# Delete single file
rm startup_script.sh
# Delete with confirmation
rm -i health_check_backup.sh
# Delete multiple files
rm health_check_v2.sh deployment.sh
# Delete directory and contents
rm -r ~/devops-projects/scripts-backup
# Force delete without confirmation (DANGEROUS - use carefully!)
rm -rf ~/devops-projects/logs/app/*

Task 4: Viewing and Searching Files
Part A: Viewing File Content
# Navigate to system logs
cd /var/log
# View entire file
cat syslog
# View file with line numbers
cat -n syslog | head -20
# View file page by page (Space=next page, q=quit)
less syslog
# View first 10 lines
head syslog
# View first 20 lines
head -n 20 syslog
# View last 10 lines
tail syslog
# View last 50 lines
tail -n 50 syslog
# Monitor file in real-time (like watching logs)
tail -f syslog
# Press Ctrl+C to stop

Part B: Searching with grep
# Search for word "error" in file
grep "error" syslog
# Case-insensitive search
grep -i "error" syslog
# Show line numbers
grep -n "error" syslog
# Search recursively in directory
grep -r "error" /var/log/
# Count occurrences
grep -c "error" syslog
# Show lines that DON'T contain pattern
grep -v "error" syslog
# Search for multiple patterns
grep -E "error|warning|critical" syslog
# Search with context (3 lines before and after)
grep -C 3 "error" syslog

Part C: Practical Log Analysis
cd ~
# Create sample log file
cat > ~/devops-projects/logs/app/application.log << 'EOF'
2024-01-15 10:23:45 INFO User login successful - user_id: 1001
2024-01-15 10:24:12 ERROR Database connection failed - timeout
2024-01-15 10:24:15 WARNING Retrying database connection
2024-01-15 10:24:18 INFO Database connection established
2024-01-15 10:25:30 ERROR Invalid API key provided
2024-01-15 10:26:45 INFO User logout - user_id: 1001
2024-01-15 10:27:12 CRITICAL System memory threshold exceeded
2024-01-15 10:28:00 ERROR Failed to send email notification
2024-01-15 10:28:30 WARNING Cache size approaching limit
2024-01-15 10:29:15 INFO Scheduled backup completed successfully
EOF
# Now analyze it
cd ~/devops-projects/logs/app/
# Find all errors
grep "ERROR" application.log
# Count errors
grep -c "ERROR" application.log
# Find errors and warnings
grep -E "ERROR|WARNING" application.log
# Find all entries for specific user
grep "user_id: 1001" application.log
# Extract just the timestamps of errors
grep "ERROR" application.log | cut -d' ' -f1,2

Task 5: Text Processing with awk and sed 
# Print specific column (space-separated)
awk '{print $1, $2}' application.log
# Print lines containing ERROR
awk '/ERROR/ {print}' application.log
# Print ERROR lines with line numbers
awk '/ERROR/ {print NR, $0}' application.log
# Print only timestamps and log levels
awk '{print $1, $2, $3}' application.log
# Count log levels
awk '{print $3}' application.log | sort | uniq -c
# Advanced: Print ERROR and line number
awk '/ERROR/ {print "Line " NR ": " $0}' application.log
Part B: Using sed (Stream editor)
# Replace ERROR with FIXED
sed 's/ERROR/FIXED/' application.log
# Replace globally (all occurrences)
sed 's/ERROR/FIXED/g' application.log
# Save changes to file (in-place editing)
sed -i 's/ERROR/FIXED/g' application.log
# Delete lines containing ERROR
sed '/ERROR/d' application.log
# Print only lines 2-5
sed -n '2,5p' application.log
# Add text at beginning of each line
sed 's/^/LOG: /' application.log
Part C: Combining Commands with Pipes
# Recreate log file first
cat > application.log << 'EOF'
2024-01-15 10:23:45 INFO User login successful - user_id: 1001
2024-01-15 10:24:12 ERROR Database connection failed - timeout
2024-01-15 10:24:15 WARNING Retrying database connection
2024-01-15 10:24:18 INFO Database connection established
2024-01-15 10:25:30 ERROR Invalid API key provided
2024-01-15 10:26:45 INFO User logout - user_id: 1001
2024-01-15 10:27:12 CRITICAL System memory threshold exceeded
2024-01-15 10:28:00 ERROR Failed to send email notification
2024-01-15 10:28:30 WARNING Cache size approaching limit
2024-01-15 10:29:15 INFO Scheduled backup completed successfully
EOF
# Find errors and sort by time
grep "ERROR" application.log | sort
# Count each log level
cat application.log | awk '{print $3}' | sort | uniq -c
# Get unique timestamps
cat application.log | awk '{print $1}' | sort -u
# Complex: Extract and count error types
grep "ERROR" application.log | awk -F'-' '{print $2}' | sort | uniq -c
System Information Commands 
Part A: System Resources
# Show system information
uname -a
# Show OS release info
cat /etc/os-release
# Show CPU information
lscpu
# Show memory usage
free -h
# Show disk usage
df -h
# Show disk usage of current directory
du -sh *
# Show disk usage sorted by size
du -sh * | sort -h
# Real-time system monitor
htop
# Press F10 or q to quit
# Show running processes
ps aux
# Show processes in tree format
ps auxf
# Show top processes by CPU
ps aux --sort=-%cpu | head -10
# Show top processes by memory
ps aux --sort=-%mem | head -10
Part B: Network Information
# Show IP address
ip addr show
# Or shorter:
ip a
# Show network interfaces
ifconfig
# If not found: sudo apt install net-tools -y
# Show routing table
ip route
# Test connectivity
ping -c 4 google.com
# Show listening ports
sudo netstat -tulpn
# Or with ss:
sudo ss -tulpn
# Show active connections
netstat -an
# DNS lookup
nslookup google.com
dig google.com
Part C: User and Permission Info
# Show current user
whoami
# Show user ID
id
# Show all logged in users
who
# Show last logins
last | head -20
# Show groups current user belongs to
groups
# Show detailed user info
finger $(whoami)
# If not found: sudo apt install finger -y
File Permissions and Ownership 
Understanding Permissions
-rwxrw-r-- 1 user group 1024 Jan 15 10:30 file.txt
│││││││││
│││││││││
│││││││└─→ Other permissions (read)
││││││└──→ Group permissions (read, write)
│││││└───→ User/Owner permissions (read, write, execute)
││││└────→ File type (- = regular file, d = directory)
Part A: Viewing Permissions
cd ~/devops-projects/scripts/bash
# Create test file
echo "echo 'Hello DevOps'" > test_script.sh
# View permissions
ls -l test_script.sh
# View with details
stat test_script.sh
Changing Permissions with chmod
# Add execute permission for owner
chmod u+x test_script.sh
# Add execute for everyone
chmod +x test_script.sh
# Remove execute from group
chmod g-x test_script.sh
# Set specific permissions (rwxr-xr--)
chmod 754 test_script.sh
# Common permission sets:
# 755 = rwxr-xr-x (scripts, executables)
# 644 = rw-r--r-- (regular files)
# 700 = rwx------ (private files)
# 777 = rwxrwxrwx (everyone full access - AVOID!)
# Make script executable
chmod +x test_script.sh
# Test it
./test_script.sh
Part C: Numeric Permissions Explained
Read (r) = 4
Write (w) = 2
Execute (x) = 1
Examples:
7 = 4+2+1 = rwx (read, write, execute)
6 = 4+2 = rw- (read, write)
5 = 4+1 = r-x (read, execute)
4 = 4 = r-- (read only)
0 = 0 = --- (no permissions)
755 means:
7 (owner) = rwx
5 (group) = r-x
5 (others) = r-x
Part D: Changing Ownership
# View current owner
ls -l test_script.sh
# Change owner (need sudo)
sudo chown root test_script.sh
# Change back to yourself
sudo chown $USER test_script.sh
# Change owner and group
sudo chown $USER:$USER test_script.sh
# Change recursively for directory
sudo chown -R $USER:$USER ~/devops-projects/
Real-World Practice Scenarios
Scenario 1: Emergency Log Analysis (30 minutes)
Situation: Your web server is experiencing issues. Analyze logs to find problems.
# Create realistic log file
mkdir -p ~/devops-projects/logs/nginx
cat > ~/devops-projects/logs/nginx/access.log << 'EOF'
192.168.1.100 - - [15/Jan/2024:10:23:45 +0000] "GET /index.html HTTP/1.1" 200 1024
192.168.1.101 - - [15/Jan/2024:10:24:12 +0000] "POST /api/login HTTP/1.1" 500 256
192.168.1.102 - - [15/Jan/2024:10:24:15 +0000] "GET /api/users HTTP/1.1" 200 2048
192.168.1.101 - - [15/Jan/2024:10:24:18 +0000] "POST /api/login HTTP/1.1" 500 256
192.168.1.103 - - [15/Jan/2024:10:25:30 +0000] "GET /images/logo.png HTTP/1.1" 404 128
192.168.1.100 - - [15/Jan/2024:10:26:45 +0000] "GET /dashboard HTTP/1.1" 200 4096
192.168.1.104 - - [15/Jan/2024:10:27:12 +0000] "POST /api/data HTTP/1.1" 503 512
192.168.1.101 - - [15/Jan/2024:10:28:00 +0000] "POST /api/login HTTP/1.1" 500 256
192.168.1.105 - - [15/Jan/2024:10:28:30 +0000] "GET /products HTTP/1.1" 200 8192
192.168.1.103 - - [15/Jan/2024:10:29:15 +0000] "GET /images/banner.jpg HTTP/1.1" 404 128
EOF
cd ~/devops-projects/logs/nginx
# Your tasks:
# 1. Count total requests
wc -l access.log
# 2. Find all 500 errors
grep " 500 " access.log
# 3. Count 500 errors
grep -c " 500 " access.log
# 4. Find which IP is causing most 500 errors
grep " 500 " access.log | awk '{print $1}' | sort | uniq -c | sort -nr
# 5. Find all 404 errors
grep " 404 " access.log
# 6. List all unique IPs
awk '{print $1}' access.log | sort -u
# 7. Count requests per IP
awk '{print $1}' access.log | sort | uniq -c | sort -nr
# 8. Find most requested URLs
awk '{print $7}' access.log | sort | uniq -c | sort -nr
# 9. Count each HTTP status code
awk '{print $9}' access.log | sort | uniq -c
# 10. Create incident report
Day 2 Summary: What You've Mastered
✅ File System Navigation:
pwd, ls, cd, tree
Absolute vs relative paths
✅ File Operations:
Creating: touch, echo, cat
Copying: cp
Moving/Renaming: mv
Deleting: rm
✅ Text Processing:
Viewing: cat, less, head, tail
Searching: grep
Processing: awk, sed
Combining: pipes |
✅ System Information:
System: uname, free, df, du
Processes: ps, top, htop
Network: ip, ping, netstat
Users: whoami, who, id
cat > incident_report.txt << 'REPORT'
INCIDENT REPORT - $(date)
========================
Total Requests: $(wc -l < access.log)
500 Errors: $(grep -c " 500 " access.log)
404 Errors: $(grep -c " 404 " access.log)
Top offending IP:
$(grep " 500 " access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -1)
Action Required: Investigate login API endpoint
