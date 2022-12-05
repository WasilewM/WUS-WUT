#!/bin/sh

# infrastructure

# create resource group
az group create --location westeurope --name wus-lab1-rg

# create VMs
## db
az vm create -n wus-lab1-db -g wus-lab1-rg --image Canonical:0001-com-ubuntu-server-jammy-daily:22_04-daily-lts-gen2:22.04.202211100 --generate-ssh-keys
## backend
az vm create -n wus-lab1-backend -g wus-lab1-rg --image Canonical:0001-com-ubuntu-server-jammy-daily:22_04-daily-lts-gen2:22.04.202211100 --generate-ssh-keys
## frontend
az vm create -n wus-lab1-frontend -g wus-lab1-rg --image Canonical:0001-com-ubuntu-server-jammy-daily:22_04-daily-lts-gen2:22.04.202211100 --generate-ssh-keys