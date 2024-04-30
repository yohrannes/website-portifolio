#!/bin/sh

# code goes here.
echo "This is a script, run by cron! - Project updated"
python3 ci-cd-scripts/get-last-commit.py
