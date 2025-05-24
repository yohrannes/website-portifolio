#!/bin/sh
mkdir -p /config/fail2ban/filter.d
echo "$F2B_HTTP_INJ_FILTER_DECODED" > /config/fail2ban/filter.d/http-injection.conf
exec /init