#!/bin/bash
# Test if file exists
file="/etc/passwd"
if [ -f "$file" ]; then
    echo " File $file exists."
else
    echo " File $file does not exist."
fi

# Test if directory exists
echo ""
dir="/var/log"
if [ -d $dir ]; then
    echo " Directory $dir exists."
else
    echo " Directory $dir does not exist."
fi
# Test if file is readable
echo ""
if [ -r "$file" ]; then
    echo " File $file is readable."
else
    echo " File $file is not readable."
fi
# Test if file is writable
echo ""
if [ -w "$file" ]; then
    echo " File $file is writable."
else
    echo " File $file is not writable."
fi
# Test if file is executable
echo ""
script="./conditonals.sh"
if [ -x "$script" ]; then
    echo " File $script is executable."
else
    echo " File $script is not executable."
fi

# Test if file is executable
echo ""
file1="./user_input.sh"
if [ -x "$file1" ]; then
    echo "File is executable."
else
  echo "File is not executable."
fi

# Test if the file is empty
echo ""
empty_file="./empty.txt"
if [ -s "$empty_file" ]; then
    echo " File $empty_file is not empty."
else
    echo " File $empty_file is empty."
fi
# Test if two files are the same
echo ""
file2="./file1.txt"
file3="./file2.txt"
if [ "$file2" -ef "$file3" ]; then
    echo " File $file2 and $file3 are the same."
else
    echo " File $file2 and $file3 are different."
fi
# Clean up
rm ./empty.txt ./file1.txt ./file2.txt

# Multiple Conditions with AND (&&)
echo ""
dir="/var/log"
if [ -d "$dir" ] && [ -r "$dir" ]; then
    echo " Directory $dir exists and is readable."
else
    echo " Directory $dir either does not exist or is not readable."
fi
# Multiple Conditions with OR (||)
echo ""
if [ -d "$dir" ] || [ -r "$dir" ]; then
    echo " Directory $dir exists or is readable."
else
    echo " Directory $dir neither exists nor is readable."
fi