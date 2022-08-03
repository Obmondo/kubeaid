#!/bin/bash
set -e
resource_group_name=$1
json_array=$(az resource list --resource-group "${resource_group_name}" --resource-type Microsoft.Network/virtualNetworks --query [0].id)
printf '{"base64_encoded":"%s"}\n' "$(echo "${json_array}" | base64 -w 0)"
