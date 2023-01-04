#!/bin/bash
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
ansible --version