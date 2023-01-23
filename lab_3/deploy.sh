#!/bin/bash

RESOURCE_GROUP_NAME=$1
CLUSTER_NAME=$2

# create resource group
az login
az group create --name $RESOURCE_GROUP_NAME --location westeurope

# create aks cluster
az aks create --resource-group $RESOURCE_GROUP_NAME \
    --name $CLUSTER_NAME \
    --enable-managed-identity \
    --node-count 2 \
    --generate-ssh-keys

kubectl get nodes