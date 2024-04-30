#!/bin/sh

source /root/website-portifolio/yoh-app/bin/activate

python3 /root/website-portifolio/app.py &

crond /usr/sbin/crond -f -l 8
