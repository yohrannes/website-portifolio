#!/bin/sh

# Clone project
git clone https://github.com/yohrannes/website-portifolio.git /root/website-portifolio

# Activate environment variable
source /root/website-portifolio/yoh-app/bin/activate

# Run aplication
python3 /root/website-portifolio/app.py &

# Run cron jobs
/usr/sbin/crond -f -l 8
