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