#!/bin/bash

export DOMAIN=terraform.kalli.app

sleep 25
apt-get update
apt-get -y install haproxy

add-apt-repository ppa:certbot/certbot
apt-get update
apt-get -y install certbot

certbot certonly --standalone --preferred-challenges http --http-01-port 80 -d $DOMAIN

mkdir -p /etc/haproxy/certs

cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem

chmod -R go-rwx /etc/haproxy/certs

