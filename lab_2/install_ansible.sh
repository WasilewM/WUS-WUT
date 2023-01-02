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

# Now manually create inventory file from provided template.
#
# Then copy the id_rsa.pem from your bash console to the vm0-ansible.
#
# Next, change permission for the key file with the following command
# chmod 600 id_rsa.pem
#
# Finaly, you can check connection with the following command:
# ansible -i inventory.yaml all -m ping
# expected answer:
# host1 | SUCCESS => {
#     "ansible_facts": {
#         "discovered_interpreter_python": "/usr/bin/python3"
#     },
#     "changed": false,
#     "ping": "pong"
# }
# host2 | SUCCESS => {
#     "ansible_facts": {
#         "discovered_interpreter_python": "/usr/bin/python3"
#     },
#     "changed": false,
#     "ping": "pong"
# }