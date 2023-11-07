include "root" {
  path = find_in_parent_folders()
}

# Use Terragrunt to download the module code
terraform {
  source = "${get_parent_terragrunt_dir()}/../../terraform//azure/peering"
}

dependency "aks" {
  config_path = "../"
  mock_outputs = {
    cluster_vnet_id = "/subscriptions/bd59662e-a78e-4d7c-84f6-9d9ad1883726/resourceGroups/MC_k8s-qa-az1_qa_az1_abc_eu_northeurope/providers/Microsoft.Network/virtualNetworks/aks-vnet-41315820"
    private_dns_zone_name = "863397e9-10d3-4075-b3ea-116f8fe4612d.privatelink.northeurope.azmk8s.io"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = merge(
  local.vars.locals.customer_vars,
  {
    cluster_vnet_id       = dependency.aks.outputs.cluster_vnet_id,
    private_dns_zone_name = dependency.aks.outputs.private_dns_zone_name,
  }
)
