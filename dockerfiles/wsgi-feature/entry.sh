#!/bin/sh

# Clone project
git clone https://github.com/yohrannes/website-portifolio.git /home/user/website-portifolio

# Activate environment variable
source /home/user/website-portifolio/venv/bin/activate

# Run aplication
python3 /home/user/website-portifolio/app.py &

# Run cron jobs
/usr/sbin/crond -f -l 8
