FROM linuxserver/fail2ban:1.1.0

LABEL maintainer="yohrannes@gmail.com"

USER root

RUN mkdir -p /etc/fail2ban/filter.d

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD fail2ban-client ping | grep -q "Server replied: pong"