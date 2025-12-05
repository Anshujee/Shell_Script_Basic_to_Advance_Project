#!/bin/bash
# Basic if statement
age=32
if [ $age -gt 18 ]; then
    echo " You are an adult"
fi

# Basic if-else statement
echo ""
if [ $age -ge 18 ]; then
    echo " You are eligible to vote."
else 
    echo "You are not eleigible to vote."
fi

# if-elif-else statement
echo ""
marks=98
if [ $marks -ge 90 ]; then 
   echo " You got A+ grade."
elif [ $marks -ge 75 ]; then
    echo " You got A grade."
    elif [ $marks -ge 60 ]; then
    echo " You got B grade."
    elif [ $marks -ge 50 ]; then
    echo " You got C grade."
    else 
    echo " You failed the exam."
    fi

# Nested if statement
echo ""
num=14
if [ $num -gt 0 ]; then
    echo " $num is a positive number."
    echo""
    if [ $((num % 2)) -eq 0 ]; then
        echo " $num is an even number."
    else
        echo " $num is an odd number."
    fi
else
    echo " $num is not a positive number."
fi

# check if string is empty
echo ""
str=""
if [ -z "$str" ]; then
    echo " String is empty."
else
    echo " String is not empty."
fi

# check if string is not empty
echo ""
str="Hello"
if [ -n "$str" ]; then
    echo " String is not empty."
else
    echo " String is empty."
fi