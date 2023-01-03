#!/bin/bash

frontend_ip=13.81.215.203
backend_ip=13.81.24.16
ansible_ip=13.81.32.202

scp /home/$USER/.ssh/id_rsa $USER@$ansible_ip:/root/id_rsa.pem

az vm run-command invoke \
    --command-id RunShellScript \
    --name wus-lab1-vm0-ansible \
    --resource-group wus-lab2-rg \
    --scripts "@./ansible.sh" \
    --parameters ${frontend_ip} ${backend_ip} $USER
