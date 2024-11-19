#FROM arm64v8/alpine
FROM alpine
WORKDIR /root
# Upgrading system
RUN apk update
RUN apk upgrade

# Installing useful programs
RUN apk add --upgrade --no-cache nano

#Provide application content
RUN mkdir /root/website-portifolio
COPY . /root/website-portifolio
RUN apk add --upgrade --no-cache git

# Installing python and flask
ENV PYTHONUNBUFFERED=1
RUN apk add --update python3 --no-cache py3-pip
RUN apk add --upgrade python3 --no-cache py3-pip
RUN ln -sf python3 /usr/bin/python

RUN apk add --no-cache py3-flask py3-requests
RUN apk add --upgrade --no-cache nano
RUN set FLASK_ENV=development
EXPOSE 5000

# Config crond and app
ADD build-app/crontab.txt /crontab.txt
ADD build-app/script.sh /script.sh
ADD build-app/entry.sh /entry.sh
RUN chmod 755 /script.sh /entry.sh
RUN /usr/bin/crontab /crontab.txt

CMD ["/entry.sh"]
