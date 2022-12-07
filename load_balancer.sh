#!/bin/bash

MY_PORT="$1"
SERVER_1_IP="$2"
SERVER_1_PORT="$3"
SERVER_2_IP="$4"
SERVER_2_PORT="$5"
SERVER_3_IP="$6"
SERVER_3_PORT="$7"


sudo apt update -y
sudo apt install -y nginx

cat << EOF > /etc/nginx/sites-enabled/lb
http {
    upstream myapp1 {
        server $SERVER_1_IP:$SERVER_1_PORT;
        server $SERVER_2_IP:$SERVER_2_PORT;
        server $SERVER_3_IP:$SERVER_3_PORT;
    }

    server {
        listen $MY_PORT;

        location / {
            proxy_pass http://myapp1;
        }
    }
}
EOF

sudo nginx -s reload