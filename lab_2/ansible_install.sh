az group create --location westeurope --name wus-lab2-rg

az vm create -n wus-lab2-vm1 -g wus-lab2-rg --image UbuntuLTS --generate-ssh-keys --public-ip-sku Standard

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
export PATH=/home/user/.local/bin:$PATH