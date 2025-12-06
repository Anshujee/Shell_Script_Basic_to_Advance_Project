#!/bin/bash
# For loop example
echo " ==== Simple Number Sequence ===="
for i in 1 2 3 4 5 6 ; do
    echo " Number: $i"
done
echo ""
# For loop in Range of Numbers
echo " ==== Number Range from 1 to 10 ===="
for i in {1..10} ; do
    echo " Number: $i"
done
echo ""
# Range with Step for Linux Systems
echo " ==== Number Range from 1 to 20 with step of 2 ===="
for i in {1..20..2} ; do
    echo " Number: $i"
done
# For Mac book 
echo "==== Number Range from 1 to 20 with step of 2 ===="
for i in $(seq 1 2 20); do
    echo " Number: $i"
done

echo ""
# Range with steps for Linux Systems

echo " ==== Number Range from 10 to 1 with step of -1 ===="
for i in {10..1..-1} ; do
    echo " Number: $i"
done

# For Mac book
echo " ==== Number Range from 10 to 1 with step of -1 ===="
for i in $(seq 10 -2 1); do
    echo " Number: $i"
done
echo ""
# Loop through C -style syntax
echo " ==== C-Style For Loop from 1 to 5 ===="
for (( i=1; i<=10; i++ )); do
    echo " Number: $i"
done
echo ""
# Loop through an array
echo " ==== Loop through an Array of Fruits ===="
fruits=("Apple" "Banana" "Mango" "Grapes" "Oranges")
for fruit in "${fruits[@]}"; do
    echo " Fruit: $fruit"
done
echo ""
# Loop through files in a directory
echo " ==== Loop through Files in /etc Directory ===="
for file in /etc/*; do
    echo " File: $(basename "$file")"
done
echo ""
# Nested for loop example
echo " ==== Nested For Loop: Multiplication Table (1 to 5) ===="
for i in {0..5}; do
    for j in {0..5}; do
        product=$((i * j))
      echo -n "$product" 
    done
    echo ""
done
echo ""
#for MAC book
#!/bin/bash

echo " ==== Nested For Loop: Multiplication Table (0 to 5) ===="

for i in $(seq 0 5); do
    for j in $(seq 0 10); do
        product=$((i * j))
        echo -n "$product "
    done
    echo ""
done
echo ""
