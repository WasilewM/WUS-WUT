#!/bin/bash

name=$1
resource_group=$2
db_ip=$3
db_port=$4

az vm run-command invoke --command-id RunShellScript \
                         --name $name \
                         --resource-group $resource_group \
                         --scripts "cd /root;
sudo apt update;
sudo apt upgrade -y;
sudo apt install -y default-jre;
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git;
cd spring-petclinic-rest;
sed -i 's/localhost/"$db_ip"/g' src/main/resources/application-mysql.properties; 
sed -i 's/3306/"$db_port"/g' src/main/resources/application-mysql.properties;
./mvnw spring-boot:run &"
