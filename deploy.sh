#!/bin/bash
source parse_yaml.sh

eval $(parse_yaml $1)

# echo $vms_

az group create --location westeurope --name $rg_name

az network vnet create \
  --name network \
  --resource-group $rg_name \
  --address-prefix 10.0.0.0/16

for group in $network_sec_groups_; do
    name=${group}_name
    rule_name=${group}_rule_name
    rule_access=${group}_rule_access
    rule_protocol=${group}_rule_protocol
    rule_priority=${group}_rule_priority
    rule_src_addr_pref=${group}_rule_src_addr_pref
    rule_src_port_ranges=${group}_rule_src_port_ranges
    rule_dst_addr_pref=${group}_rule_dst_addr_pref
    rule_dst_port_ranges=${group}_rule_dst_port_ranges

    echo "creating network security group ${!name}"
    az network nsg create \
        --resource-group $rg_name \
        --name ${!name}
    
    echo "creating network security group rule ${!name}"
    az network nsg rule create \
        --resource-group $rg_name \
        --nsg-name ${!name} \
        --name ${!rule_name} \
        --access ${!rule_access} \
        --protocol ${!rule_protocol} \
        --priority ${!rule_priority} \
        --source-address-prefix "${!rule_src_addr_pref}" \
        --source-port-range "${!rule_src_port_ranges}" \
        --destination-address-prefix "${!rule_dst_addr_pref}" \
        --destination-port-range "${!rule_dst_port_ranges}"
    
done

for subnet in $subnets_; do
    name=${subnet}_name
    addr_pref=${subnet}_addr_pref
    nsg=${subnet}_nsg

    echo "creating network subnet ${!name}"
    az network vnet subnet create \
        --resource-group $rg_name \
        --vnet-name network \
        --name ${!name} \
        --address-prefix ${!addr_pref} \
        --network-security-group ${!nsg}
done


for IP in $public_ips_
do
    echo "creating public IP (${!IP})"
    az network public-ip create \
        --resource-group $rg_name \
        --name ${!IP}
done


for VM in $vms_
do
    subnet=${VM}_subnet
    nsg=${VM}_nsg
    public_ip=${VM}_public_ip
    name=${VM}_name
    IP=${VM}_IP

    echo "creating VM ${!name}"
    az vm create \
        --name ${!name} \
        --resource-group $rg_name \
        --image Canonical:0001-com-ubuntu-server-jammy-daily:22_04-daily-lts-gen2:22.04.202211100 \
        --generate-ssh-keys \
        --vnet-name network \
        --subnet ${!subnet} \
        --nsg ${!nsg} \
        --private-ip-address ${!IP} \
        --public-ip-address "${!public_ip}"
done

for component in $components_
do
    type=${component}_type
    vm_name=${component}_vm_name
    IP=${component}_IP
    port=${component}_port

    echo "deploying component of type ${!type} on vm ${!vm_name}"

    if [ ${!type} == "db_master" ]; then
        az vm run-command invoke \
            --command-id RunShellScript \
            --name ${!vm_name} \
            --resource-group $rg_name \
            --scripts "@./database.sh" \
            --parameters ${!port}
    fi

    if [ ${!type} == "db_slave" ]; then
        # @TODO add params 
        az vm run-command invoke \
            --command-id RunShellScript \
            --name ${!vm_name} \
            --resource-group $rg_name \
            --scripts "@./database_slave.sh" \
            --parameters ${!port} ${!master_db_address} ${!master_db_port}
    fi

    if [ ${!type} == "backend" ]; then
        db_vm_name=${component}_related_1
        db_ip=vms_${!db_vm_name}_IP
        db_port=components_${!db_vm_name}_port

        az vm run-command invoke \
            --command-id RunShellScript \
            --name ${!vm_name} \
            --resource-group $rg_name \
            --scripts "@./backend.sh" \
            --parameters ${!port} ${!db_ip} ${!db_port}
    fi

    if [ ${!type} == "load_balancer" ]; then
        vm_config_name=${component}_vm_config
        my_ip=vms_${!vm_config_name}_IP        
        my_port=${component}_port

        backend_1_component_name=${component}_related_1_component
        backend_1_vm=${component}_related_1_vm
        backend_1_ip=vms_${!backend_1_vm}_IP
        backend_1_port=components_${!backend_1_component_name}_port

        backend_2_component_name=${component}_related_2_component
        backend_2_vm=${component}_related_2_vm
        backend_2_ip=vms_${!backend_2_vm}_IP
        backend_2_port=components_${!backend_2_component_name}_port

        backend_3_component_name=${component}_related_3_component
        backend_3_vm=${component}_related_3_vm
        backend_3_ip=vms_${!backend_3_vm}_IP
        backend_3_port=components_${!backend_3_component_name}_port

        az vm run-command invoke \
            --command-id RunShellScript \
            --name ${!name} \
            --resource-group $rg_name \
            --scripts "@./load_balancer.sh" \
            --parameters ${!my_ip} ${!my_port} ${!backend_1_ip} ${!backend_1_port} ${!backend_2_ip} ${!backend_2_port} ${!backend_3_ip} ${!backend_3_port}
    fi

    if [ ${!type} == "frontend" ]; then
        backend_component_name=${component}_related_1_component
        backend_vm_name=${component}_related_1_vm
        backend_public_ip_name=vms_${!backend_vm_name}_public_ip
        backend_ip=$(az network public-ip show --resource-group $rg_name --name ${!backend_public_ip_name} --query "ipAddress" --output tsv)
        backend_port=components_${!backend_component_name}_port
        frontend_port=${component}_port

        az vm run-command invoke \
            --command-id RunShellScript \
            --name ${!vm_name} \
            --resource-group $rg_name \
            --scripts "@./frontend.sh" \
            --parameters ${backend_ip} ${!backend_port} ${!frontend_port}
    fi
done
