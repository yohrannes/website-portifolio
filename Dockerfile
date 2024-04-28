FROM alpine
WORKDIR /root
ADD . .

# Upgrading system
RUN apk update
RUN apk upgrade

# Installing python and flask

ENV PYTHONUNBUFFERED=1
RUN apk add --update python3 py3-pip
RUN apk add --upgrade python3 py3-pip
RUN ln -sf python3 /usr/bin/python
RUN apk add py3-flask py3-requests
RUN set FLASK_ENV=development
EXPOSE 5000

# Running aplication
CMD [ "python3", "/root/app.py"]
