FROM alpine
WORKDIR /root
#ADD . .

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
RUN set FLASK_ENV=development
EXPOSE 5000

# Activate environment
RUN source /root/website-portifolio/yoh-app/bin/activate

# Running aplication
CMD [ "python3", "/root/website-portifolio/app.py"]
