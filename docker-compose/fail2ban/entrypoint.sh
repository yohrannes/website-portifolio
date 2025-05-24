#!/bin/sh
mkdir -p /etc/fail2ban/filter.d
echo "$FAILREGEX_DECODED" > /etc/fail2ban/filter.d/http-injection.conf
exec /init