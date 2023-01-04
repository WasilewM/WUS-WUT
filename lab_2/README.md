1. Install vms using `deploy_infrastructure.sh`.  
2. On vm0-ansible install ansible using script `install_ansible.sh`.
3. Now manually create inventory file from provided template.  
Then copy the id_rsa.pem from your bash console to the vm0-ansible.  
Next, change permission for the key file with the following command  
```
chmod 600 id_rsa.pem
```  
Finaly, you can check connection with the following command:  
```
ansible -i inventory.yaml all -m ping
```
expected answer:
```
host1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
host2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```
3. Copy vars/ and scripts/ directories to vm0-ansible.  
4. Run playbook using following command:  
```
ansible-playbook playbook1.yaml -i inventory.yaml
```
For debug info add `-vvv` to the command above.