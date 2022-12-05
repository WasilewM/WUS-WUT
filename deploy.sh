#!/bin/bash
source parse_yaml.sh

eval $(parse_yaml $1)

# echo $vms_

az group create --location westeurope --name $rg_name

az network vnet create \
  --name network \
  --resource-group $rg_name \
  --subnet-name subnet \
  --address-prefix 10.0.0.0/16

for VM in $vms_
do
    name=${VM}_name
    IP=${VM}_IP
    echo ${!name}
    az vm create \
        --name ${!name} \
        --resource-group $rg_name \
        --image \ Canonical:0001-com-ubuntu-server-jammy-daily:22_04-daily-lts-gen2:22.04.202211100 \
        --generate-ssh-keys \
        --vnet-name network \
        --subnet subnet \
        --private-ip-address ${!IP} 
done

