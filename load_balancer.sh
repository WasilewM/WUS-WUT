#!/bin/bash

MY_IP="$1"
MY_PORT="$2"
SERVER_1_IP="$3"
SERVER_1_PORT="$4"
SERVER_2_IP="$5"
SERVER_2_PORT="$6"
SERVER_3_IP="$7"
SERVER_3_PORT="$8"


sudo apt update -y
sudo apt install -y nginx

cat << EOF > /etc/nginx/sites-enabled/lb
upstream backend {
    server $SERVER_1_IP:$SERVER_1_PORT;
    server $SERVER_2_IP:$SERVER_2_PORT;
    server $SERVER_3_IP:$SERVER_3_PORT;
}

server {
    listen $MY_PORT;

    location / {
        proxy_pass http://backend;
        include proxy_params;
    }
}
EOF

sudo nginx -s reload