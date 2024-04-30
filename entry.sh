#!/bin/sh

crond /usr/sbin/crond -f -l 8 &
python3 /root/website-portifolio/app.py &
