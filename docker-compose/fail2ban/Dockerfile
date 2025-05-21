FROM linuxserver/fail2ban
LABEL maintainer="yohrannes@gmail.com"

ENTRYPOINT ["/bin/sh", "-c", "echo \"$FAILREGEX_DECODED\" > /etc/fail2ban/filter.d/http-injection.conf && /init"]