#!/bin/sh
mkdir -p /etc/fail2ban/filter.d
echo "$FAILREGEX_DECODED" > /etc/fail2ban/filter.d/http-injection.conf
chown abc:abc /etc/fail2ban/filter.d/http-injection.conf
exec s6-setuidgid abc /init