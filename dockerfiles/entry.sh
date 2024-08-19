#!/bin/sh

# Clone project
git clone https://github.com/yohrannes/website-portifolio.git /root/website-portifolio

# Activate environment variable
#python3 -m venv /root/website-portifolio/venv
#source /root/website-portifolio/venv/bin/activate

# Run aplication
python3 /root/website-portifolio/app.py &
#uwsgi --http-socket :9090 --plugin python --wsgi-file foobar.py
# Run cron jobs
/usr/sbin/crond -f -l 8
