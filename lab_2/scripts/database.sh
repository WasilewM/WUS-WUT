#!/bin/bash
port=$1

echo "### BEFORE SCRIPT CLEANUP STARTED"
if [ -d ./database ]
then
    echo "Removed existing ./database directory"
	sudo rm -rf ./database
fi

echo "sudo mysql -e DROP USER pc;"
sudo mysql -e "DROP USER pc;"

echo "sudo mysql -e DROP DATABASE petclinic;"
sudo mysql -e "DROP DATABASE petclinic;"

if [ ! -d ./database ]
then
	echo "Create new ./database directory"
	mkdir ./database
fi

echo "### BEFORE SCRIPT CLEANUP FINISHED"
cd database

sudo apt update
sudo apt upgrade -y
sudo apt install -y mysql-server

echo "[mysqld]" | sudo tee -a /etc/mysql/my.cnf
echo "port=$port" | sudo tee -a /etc/mysql/my.cnf
echo "bind-address = 0.0.0.0" | sudo tee -a /etc/mysql/my.cnf
echo "server-id = 1" | sudo tee -a /etc/mysql/my.cnf
echo "log_bin = /var/log/mysql/mysql-bin.log" | sudo tee -a /etc/mysql/my.cnf

sudo service mysql restart

sudo mysql -e "CREATE USER IF NOT EXISTS 'pc'@'%' IDENTIFIED BY 'petclinic';"

wget https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/initDB.sql
sed -i "s/GRANT ALL PRIVILEGES ON petclinic.* TO pc@localhost IDENTIFIED BY 'pc';/GRANT ALL PRIVILEGES ON petclinic.* TO 'pc'@'%' WITH GRANT OPTION;/g" ./initDB.sql
cat initDB.sql | sudo mysql -f

wget https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/populateDB.sql
sed -i '1 i\USE petclinic;' ./populateDB.sql
cat populateDB.sql | sudo mysql -f

sudo mysql -v -e "UNLOCK TABLES;"
