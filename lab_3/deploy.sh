#!/bin/bash

# 1. create AKS cluster
# this needs to be done manualy

# 2. login to docker hub
DOCKER_LOGIN=$1
# cannot pass 34 chars long password - max 32 chars can be passed
DOCKER_PASSWORD=$2
export REPOSITORY_PREFIX=$1

# "Using STDIN prevents the password from ending up in the shell’s history, or log-files"
# source: https://docs.docker.com/engine/reference/commandline/login/#-provide-a-password-using-stdin---password-stdin
echo $DOCKER_PASSWORD | docker login --username $DOCKER_LOGIN --password-stdin

# 3. clone git repository
git clone https://github.com/spring-petclinic/spring-petclinic-cloud.git
cd spring-petclinic-cloud

# 3. build docker images
# some problems with docker daemon occur
./mvnw spring-boot:build-image -Pk8s -DREPOSITORY_PREFIX=$REPOSITORY_PREFIX

# 4. push images to container registry
./scripts/pushImages.sh

# 5. get kubectl credentials
az account set --subscription <UZUPELNIC>
az aks get-credentials --resource-group <UZUPELNIC> --name <UZUPELNIC>

# 6. create k8s ns
kubectl apply -f k8s/init-namespace/ 

# 8. init services
kubectl apply -f k8s/init-services

# 9. create databases (using helm) - separate database for each service
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install vets-db-mysql bitnami/mysql --namespace spring-petclinic --version 9.4.6 --set auth.database=service_instance_db
helm install visits-db-mysql bitnami/mysql --namespace spring-petclinic  --version 9.4.6 --set auth.database=service_instance_db
helm install customers-db-mysql bitnami/mysql --namespace spring-petclinic  --version 9.4.6 --set auth.database=service_instance_db

# 10. create deployments
./scripts/deployToKubernetes.sh

# 11. get external IP
sleep 5
kubectl get svc -n spring-petclinic api-gateway