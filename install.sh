#! /bin/bash
apt update
apt install -yq build-essential python3-pip gunicorn
pip install flask
git clone https://github.com/wu4f/cs430-src /root/cs430-src
cd /root/cs430-src/03_nginx_gunicorn_certbot
gunicorn --bind :80 --workers 1 --threads 8 app:app
