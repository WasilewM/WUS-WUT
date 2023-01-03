#!/bin/bash

frontend_ip=$1
backend_ip=$2

cd /root
sudo apt update -y
sudo apt upgrade -y
sudo apt install software-properties-common -y

python3 -V
sudo apt install python3-pip -y
python3 -m pip -V
python3 -m pip install --user ansible
python3 -m pip show ansible

sudo apt install ansible-core -y
sudo apt install ansible -y

cd ~/
echo "frontend ansible_ssh_private_key_file=./id_rsa.pem ansible_user=$USER ansible_host=$frontend_ip" | sudo tee -a inventory.yaml
echo "backend ansible_ssh_private_key_file=./id_rsa.pem ansible_user=$USER ansible_host=$backend_ip" | sudo tee -a inventory.yaml

# copy id_rsa.pem before running this script

chmod 600 id_rsa.pem
ansible -i inventory.yaml all -m ping
