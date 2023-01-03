#!/bin/bash

frontend_ip=
backend_ip=
ansible_ip=

scp /home/$USER/.ssh/id_rsa $USER@$ansible_ip:~/id_rsa.pem

az vm run-command invoke \
    --command-id RunShellScript \
    --name wus-lab1-vm0-ansible \
    --resource-group wus-lab2-rg \
    --scripts "@./ansible.sh" \
    --parameters ${frontend_ip} ${backend_ip}