1. Install vms using `deploy_infrastructure.sh`.  
2. On vm0-ansible install ansible using script `install_ansible.sh`. *READ COMMENTS IN THAT FILE!*  
3. Copy vars/ and scripts/ directories to vm0-ansible.  
4. Run playbook using following command:  
```
ansible-playbook playbook1.yaml -i inventory.yaml
```