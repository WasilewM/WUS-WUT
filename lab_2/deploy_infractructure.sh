#!/bin/bash
az group create --location westeurope --name wus-lab2-rg

az vm create -n wus-lab1-vm0-ansible -g wus-lab2-rg --image UbuntuLTS --generate-ssh-keys --public-ip-sku Standard
az vm create -n wus-lab1-vm1-db-master -g wus-lab2-rg --image UbuntuLTS --generate-ssh-keys --public-ip-sku Standard
az vm create -n wus-lab1-vm2-db-slave -g wus-lab2-rg --image UbuntuLTS --generate-ssh-keys --public-ip-sku Standard
az vm create -n wus-lab1-vm3-backend -g wus-lab2-rg --image UbuntuLTS --generate-ssh-keys --public-ip-sku Standard
az vm create -n wus-lab1-vm4-slave -g wus-lab2-rg --image UbuntuLTS --generate-ssh-keys --public-ip-sku Standard
