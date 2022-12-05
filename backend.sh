#!/bin/sh

ip_address="10.0.0.4"
port=3306

az vm run-command invoke --command-id RunShellScript \
                         --name wus-lab1-backend \
                         --resource-group wus-lab1-rg \
                         --scripts "cd /root;
sudo apt update;
sudo apt upgrade -y;
sudo apt install -y default-jre;
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git;
cd spring-petclinic-rest;
sed -i 's/localhost/"$ip_address"/g' src/main/resources/application-mysql.properties; 
sed -i 's/3306/"$port"/g' src/main/resources/application-mysql.properties;
./mvnw spring-boot:run &"