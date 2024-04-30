FROM alpine
WORKDIR /root

# Upgrading system
RUN apk update
RUN apk upgrade

#Get website project from github
RUN apk add --upgrade git
RUN git clone https://github.com/yohrannes/website-portifolio.git

# Installing python and flask

ENV PYTHONUNBUFFERED=1
RUN apk add --update python3 py3-pip
RUN apk add --upgrade python3 py3-pip
RUN ln -sf python3 /usr/bin/python
RUN apk add py3-flask py3-requests
RUN apk add --upgrade nano
RUN set FLASK_ENV=development
EXPOSE 5000

# Config crond and app
ADD crontab.txt /crontab.txt
ADD script.sh /script.sh
COPY entry.sh /entry.sh
RUN chmod 755 /script.sh /entry.sh
RUN /usr/bin/crontab /crontab.txt

# Add source yoh-app/bin ... dont forget

CMD ["/entry.sh"]
