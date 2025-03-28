#FROM arm64v8/alpine
FROM alpine
LABEL maintainer="yohrannes@gmail.com"
WORKDIR /root
# Upgrading system # Installing useful programs
RUN apk update && apk upgrade && apk add --upgrade --no-cache nano git py3-flask py3-requests curl

#Provide application content
RUN mkdir /root/website-portifolio
COPY . /root/website-portifolio

# Installing python and flask
ENV PYTHONUNBUFFERED=1
RUN apk add --update python3 --no-cache py3-pip
RUN apk add --upgrade python3 --no-cache py3-pip
RUN ln -sf python3 /usr/bin/python

RUN set FLASK_ENV=development
EXPOSE 5000

# Config crond and app
ADD build-app/crontab.txt /crontab.txt
ADD build-app/script.sh /script.sh
ADD build-app/entry.sh /entry.sh
RUN chmod 755 /script.sh /entry.sh
RUN /usr/bin/crontab /crontab.txt

CMD ["/entry.sh"]
HEALTHCHECK --timeout=2s CMD curl -f localhost:5000 || exit 1
