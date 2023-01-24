#!/bin/bash

# before running the script please log in:
# azure login
# and enter displayed code in the website from provided link

RESOURCE_GROUP_NAME=$1
CLUSTER_NAME=$2

# create resource group
az group create --name $RESOURCE_GROUP_NAME --location westeurope

# create aks cluster
az aks create --resource-group $RESOURCE_GROUP_NAME \
    --name $CLUSTER_NAME \
    --enable-managed-identity \
    --node-count 2 \
    --generate-ssh-keys

az aks get-credentials \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $CLUSTER_NAME

kubectl get nodes

# deploy spring-petclinic-cloud
cd spring-petclinic-k8s/

kubectl apply -f k8s/init-namespace
kubectl apply -f k8s/init-services

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm search repo bitnami

helm install vets-db-mysql bitnami/mysql --namespace spring-petclinic --version 9.4.6 --set auth.database=service_instance_db
helm install visits-db-mysql bitnami/mysql --namespace spring-petclinic  --version 9.4.6 --set auth.database=service_instance_db
helm install customers-db-mysql bitnami/mysql --namespace spring-petclinic  --version 9.4.6 --set auth.database=service_instance_db

# spingcommunity repository on dockerhub:
# https://hub.docker.com/u/springcommunity
export REPOSITORY_PREFIX=springcommunity

./scripts/deployToKubernetes.sh

kubectl get svc -n spring-petclinic api-gateway
