FROM bitnami/apache:latest

ENV TZ=Europe/London

COPY .docker/vhost.conf /vhosts/app.conf

WORKDIR /app

COPY . /app