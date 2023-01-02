#!/bin/bash
az group create --location westeurope --name wus-lab2-rg

# WARNING: Limit: 3 public IPs 
az vm create -n wus-lab1-vm0-ansible -g wus-lab2-rg --image Canonical:0001-com-ubuntu-server-jammy-daily:22_04-daily-lts-gen2:22.04.202211100 --generate-ssh-keys --public-ip-sku Standard
az vm create -n wus-lab1-vm1-backend -g wus-lab2-rg --image Canonical:0001-com-ubuntu-server-jammy-daily:22_04-daily-lts-gen2:22.04.202211100 --generate-ssh-keys --public-ip-sku Standard
az vm create -n wus-lab1-vm2-frontend -g wus-lab2-rg --image Canonical:0001-com-ubuntu-server-jammy-daily:22_04-daily-lts-gen2:22.04.202211100 --generate-ssh-keys --public-ip-sku Standard
