FROM linuxserver/fail2ban
LABEL maintainer="yohrannes@gmail.com"

USER root

RUN mkdir -p /etc/fail2ban/filter.d

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]