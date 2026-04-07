#!/bin/bash
# Upgrade AKS cluster to latest patch
AKS_NAME=$1; RG=$2
LATEST=$(az aks get-upgrades -n $AKS_NAME -g $RG --query 'controlPlaneProfile.upgrades[-1].kubernetesVersion' -o tsv)
az aks upgrade -n $AKS_NAME -g $RG --kubernetes-version $LATEST --yes
