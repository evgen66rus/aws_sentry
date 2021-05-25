#!/bin/bash
apt update
apt install -y python3 python3-pip git docker docker.io
service docker start
git clone https://github.com/getsentry/onpremise.git
curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
cp /onpremise/sentry/sentry.conf.example.py /onpremise/sentry/sentry.conf.py
cp /onpremise/sentry/config.example.yml /onpremise/sentry/config.yml 
/onpremise/install.sh --no-user-prompt > /var/log/install.log
cd /onpremise/ && docker-compose up -d
