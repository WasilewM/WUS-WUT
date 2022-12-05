#!/bin/sh

az vm run-command invoke --command-id RunShellScript \
                         --name wus-lab1-db \
                         --resource-group wus-lab1-rg \
                         --scripts 'cd /root;
sudo apt update;
sudo apt upgrade -y;
sudo apt install -y mysql-server;
echo '[mysqld]' | sudo tee -a /etc/mysql/my.cnf;
echo "port=3306" | sudo tee -a /etc/mysql/my.cnf;
echo "bind-address = 0.0.0.0" | sudo tee -a /etc/mysql/my.cnf;
echo "server-id = 1" | sudo tee -a /etc/mysql/my.cnf;
echo "log_bin = /var/log/mysql/mysql-bin.log" | sudo tee -a /etc/mysql/my.cnf;
echo "binlog_do_db = petclinic" | sudo tee -a /etc/mysql/my.cnf;

sudo mysql -e "CREATE DATABASE IF NOT EXISTS petclinic;
    ALTER DATABASE petclinic
      DEFAULT CHARACTER SET utf8
      DEFAULT COLLATE utf8_general_ci;
    CREATE USER IF NOT EXISTS 'pc'@'%' IDENTIFIED BY 'petclinic';
    GRANT ALL PRIVILEGES ON petclinic.* TO 'pc'@'%'";

sudo service mysql restart;'