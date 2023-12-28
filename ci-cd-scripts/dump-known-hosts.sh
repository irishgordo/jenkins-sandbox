#!/usr/bin/bash

echo "previous known hosts:"
echo "======================"
cat /home/ubuntu/.ssh/known_hosts
echo "======================"

echo "dumping known hosts:"
echo "======================"
echo "" > /home/ubuntu/.ssh/known_hosts
echo "======================"

echo "current known hosts:"
echo "======================"
cat /home/ubuntu/.ssh/known_hosts
echo "======================"