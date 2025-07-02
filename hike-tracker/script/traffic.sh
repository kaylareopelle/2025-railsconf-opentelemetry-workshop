#!/bin/bash

# Trap Ctrl-C and exit
trap 'echo -e "\nCtrl-C received. Stopping traffic generator."; exit 0' SIGINT

controllers=("trails" "users" "activities")

while true; do
    n=$(( (RANDOM % 10) + 1 ))
    for controller in "${controllers[@]}"; do
        curl "http://localhost:3000/${controller}" > /dev/null 2>&1
        curl "http://localhost:3000/${controller}/${n}" > /dev/null 2>&1
    done
    sleep 1
done
