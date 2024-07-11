#!/bin/bash

# Set the file path
file="/var/log/get-last-commit.log"

# Iterate over each line in the file
while IFS= read -r line; do
    echo "${line}"
done < "$file"
