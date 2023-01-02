sudo apt update 
sudo apt upgrade
sudo apt install software-properties-common

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.9
alias python3='python3.9'

sudo apt install python3.9-distutils
sudo apt install python3-pip
python3.9 -m pip install --upgrade pip
python3 -m pip install --user ansible
# need to somehow remember the user value
export PATH=/home/user/.local/bin:$PATH

# need to capture wus-lab2-vm1 IP
ssh user@wus-lab2-vm1_IP
nano inventory.yaml
nano id_rsa.pem
chmod 600 id_rsa.pem
ansible -i inventory.yaml all -m ping
# expected answer:
# host1 | SUCCESS => {
#     "ansible_facts": {
#         "discovered_interpreter_python": "/usr/bin/python3"
#     },
#     "changed": false,
#     "ping": "pong"
# }
# host2 | SUCCESS => {
#     "ansible_facts": {
#         "discovered_interpreter_python": "/usr/bin/python3"
#     },
#     "changed": false,
#     "ping": "pong"
# }