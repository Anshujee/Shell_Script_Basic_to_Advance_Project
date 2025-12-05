#!/bin/bash
# This is a simple programm to add two number using Commamd line arrgument in Shell

echo " Script Name: $0"
echo " First argument:$1"
echo " Second argument:$2"

if [ $# -eq 0 ]; then 
    echo " Usages $0 <num1> <num2>"
    exit 1
fi

num1=$1
num2=$2

sum=$((num1 +num2))

echo "Sum of $num1 and $num2 is: $sum"