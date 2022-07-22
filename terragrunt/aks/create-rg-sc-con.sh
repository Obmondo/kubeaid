#!/bin/bash

location=$(yq '.location' "${OBMONDO_VARS_FILE}")
resource_group=$(yq '.resource_group' "${OBMONDO_VARS_FILE}")
storage_account=$(yq '.storage_account' "${OBMONDO_VARS_FILE}")
container=$(yq '.container' "${OBMONDO_VARS_FILE}")

echo "logging you into you azure account"
az login

echo "Creating your Resource group"
az group create --location "$location" --name "$resource_group"

echo "Creating the Storage account"
az storage account create -n "$storage_account" -g "$resource_group" -l "$location" --sku Standard_LRS

echo "Creating the Storage Container"
az storage container create -n "$container" --account-name "$storage_account"
