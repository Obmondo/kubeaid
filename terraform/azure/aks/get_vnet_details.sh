#!/bin/bash
set -e
resource_group_name=$1
attribute=$2
json_array=$(az resource list --resource-group "${resource_group_name}" --resource-type Microsoft.Network/virtualNetworks --query [0]."${attribute}")
printf '{"base64_encoded":"%s"}\n' "$(echo "${json_array}" | base64 -w 0)"
