#!/bin/bash

backend_port=$1
db_ip=$2
db_port=$3

echo "### BEFORE SCRIPT CLEANUP STARTED"
if [ -d ./backend ]
then
    echo "Removed existing ./backend directory" 
	sudo rm -rf ./backend
	
fi

if [ ! -d ./backend ]
then
    echo "Create new ./backend directory"
	mkdir ./backend
fi

echo "### BEFORE SCRIPT CLEANUP FINISHED"
cd backend

sudo apt update
sudo apt upgrade -y
sudo apt install -y default-jre
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
cd spring-petclinic-rest
sed -i "s/localhost/$db_ip/g" src/main/resources/application-mysql.properties
sed -i "s/3306/$db_port/g" src/main/resources/application-mysql.properties
sed -i "s/9966/$backend_port/g" src/main/resources/application.properties
sed -i "s/active=hsqldb/active=mysql/g" src/main/resources/application.properties
./mvnw spring-boot:run
