#!/bin/sh

git clone https://github.com/yohrannes/website-portifolio.git /root/website-portifolio
source /root/website-portifolio/yoh-app/bin/activate
python3 /root/website-portifolio/app.py &

crond /usr/sbin/crond -f -l 8
