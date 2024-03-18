FROM balenalib/aarch64-python AS build
WORKDIR /root
ADD . .

FROM balenalib/aarch64-alpine-node
COPY --from=build /root /root

# Installing python and flask
ENV PYTHONUNBUFFERED=1
RUN apk add --update python3 py3-pip
RUN ln -sf python3 /usr/bin/python
RUN apk add py3-flask py3-requests
RUN set FLASK_ENV=development
EXPOSE 5000

CMD [ "python3", "/root/app.py"]