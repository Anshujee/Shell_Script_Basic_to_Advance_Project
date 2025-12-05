# Script used to take user input and display it

#!/bin/bash
# This script takes user input and displays it back to the user. Simple interactive script.
echo " What is your name? " 
read name
echo " Hello, $name! Welcome to Bash Scripting."
echo " How old are you? "
read age
echo " You are $age years old."
echo " What is your favorite programming language? "
read language
echo " Great! $language is a wonderful programming language."

# Input with prompt on the same line
read -p " Enter your country: " country
echo " You are from $country."

# Silent input (for passwords)
read -sp " Enter your password: " password
echo ""
echo " Your password is securely stored."
echo " Password Length: ${#password} characters."

# Multiple inputs in one line
read -p " Enter your first name and last name: " firstname lastname
echo " Your full name is: $firstname $lastname."
echo " First Name : $firstname"
echo " Last Name : $lastname"
echo "----------------------------------------"

# Input With Default Value
read -p "Enter your city (default is 'Pune'): " city
city=${city:-Pune}
echo " You live in $city."
echo "----------------------------------------"
read -p " Enter environment [dev]: " env
env=${env:-dev}
echo " Selected environment is: $env."
echo "----------------------------------------"

# Input with timeout (5 seconds)
read -t 5 -p " Enter your favorite color (you have 5 seconds): " color
if [ -z "$color" ]; then
    echo " No input received. Using default color: Blue."
    color="Blue"
else
    echo " Your favorite color is: $color."
fi