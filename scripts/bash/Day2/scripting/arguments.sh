#!/bin/bash
# This script demonstrates the use of command-line arguments in Bash scripting.
echo "Script Name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Third argument: $3"
echo "Total number of arguments passed: $#"
echo "All argument passed: $@" 
# $@ is similar to $* but treats each quoted argument as a separate entity
echo "----------------------------------------"

# Example of using arguments in a simple operation
if [ $# -eq 0 ]; then
    echo " usages: $0 <name> <age> <city> "
    exit 1
fi
name=$1
age=$2
city=$3

echo ""
echo "Hello, my name is $name. I am $age years old and I live in $city."
echo "----------------------------------------"
echo "Name: ${name}"
echo "Age: ${age}"
echo "City: ${city}"
echo "----------------------------------------"

# Example 2 -  


if [ $# -lt 2 ]; then
    echo "Usage: $0 <num1> <num2>"
    exit 1
fi

echo " 
