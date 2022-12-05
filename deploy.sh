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
    az vm create \
        --name ${!name} \
        --resource-group $rg_name \
        --image Canonical:0001-com-ubuntu-server-jammy-daily:22_04-daily-lts-gen2:22.04.202211100 \
        --generate-ssh-keys \
        --vnet-name network \
        --subnet subnet \
        --private-ip-address ${!IP} 
done

for VM in $vms_
do
    type=${VM}_type
    vm_name=${VM}_name
    IP=${VM}_IP
    port=${VM}_port


    if [ ${!type} == "db_master" ]; then
        ./database.sh $vm_name $rg_name $port
    fi

    if [ ${!type} == "backend" ]; then
        db_vm_name=${VM}_related_1
        db_ip=$("vms_${!db_vm_name}_IP")
        db_port=$("vms_${!db_vm_name}_port")
        ./backend.sh $vm_name $rg_name $db_ip $db_port
    fi

    if [ ${!type} == "frontend" ]; then
        backend_vm_name=${VM}_related_1
        backend_ip=$("vms_${!backend_vm_name}_IP")
        backend_port=$("vms_${!backend_vm_name}_port")
        ./frontend.sh $vm_name $rg_name $backend_ip $backend_port
    fi

done