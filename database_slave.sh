#!/bin/bash
port=$1
master_address=$2
master_port=$3

cd /root
sudo apt update
sudo apt upgrade -y
sudo apt install -y mysql-server

echo "[mysqld]" | sudo tee -a /etc/mysql/my.cnf
echo "port=$port" | sudo tee -a /etc/mysql/my.cnf
echo "bind-address = 0.0.0.0" | sudo tee -a /etc/mysql/my.cnf
echo "server-id = 2" | sudo tee -a /etc/mysql/my.cnf
echo "read_only = 1" | sudo tee -a /etc/mysql/my.cnf

sudo service mysql restart

sudo mysql -e "CREATE USER IF NOT EXISTS 'pc'@'%' IDENTIFIED BY 'petclinic';"

wget https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/initDB.sql
sed -i "s/GRANT ALL PRIVILEGES ON petclinic.* TO pc@localhost IDENTIFIED BY 'pc';/GRANT ALL PRIVILEGES ON petclinic.* TO 'pc'@'%' WITH GRANT OPTION;/g" ./initDB.sql
cat initDB.sql | sudo mysql -f

wget https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/populateDB.sql

sed -i '1 i\USE petclinic;' ./populateDB.sql

cat populateDB.sql | sudo mysql -f

sudo mysql -v -e "UNLOCK TABLES;"

STATEMENT="CHANGE MASTER TO MASTER_HOST='${master_address}', MASTER_PORT=${master_port}, MASTER_USER=pc, MASTER_PASSWORD=petclinic;"

sudo mysql -v -e "${STATEMENT}"
sudo mysql -v -e "START SLAVE;"
