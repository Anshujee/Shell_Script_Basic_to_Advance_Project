# Learn Bash Scripting - Variables Demo Script

#!/bin/bash
# This script demonstrates the use of variables in Bash scripting.
name="Anshu"
age=35
company="Infosys Limited"
# Displaying/Print the values of the variables
echo "Name: $name"
echo "Age: $age"
echo "Company: $company"

# Alernate way to print the values of the variables
echo "My name is ${name}, I am ${age} years old and I work at ${company}."
echo "----------------------------------------"
echo "Name: ${name}"
echo : "Age: ${age}"
echo "Company: ${company}"

echo "----------------------------------------"
# Command substitution example -- Stoe the output of a command in a variable

current_date=$(date)
echo "Current Date and Time : $current_date"

current_user=$(whoami)
echo "Current User : $current_user"

echo "----------------------------------------"

# Arithmetic operations using variables

num1=10
num2=20
sum=$((num1 + num2))
sub=$((num2-num1))
prod=$((num1*num2))
div=$((num2/num1))
echo "Sum of $num1 and $num2 is : $sum"
echo "Subtraction of $num1 from $num2 is : $sub"
echo "Product of $num1 and $num2 is : $prod"
echo "Division of $num2 by $num1 is : $div"
echo "----------------------------------------"

# Some important System Variables in Bash
echo "Script Name : $0"
echo "Current Shell : $SHELL"
echo "Home Directory : $HOME"
echo "Current Working Directory : $PWD"
echo "User ID : $UID"
echo "Number of Arguments Passed : $#"
echo "All Arguments Passed : $*"
echo "Current user : $USER"
echo "Hostname : $HOSTNAME"
