#!/bin/bash

# Run ....
# ./push-main.sh "My commit comment"

git add .
git commit -m "${1}"
git push origin main
