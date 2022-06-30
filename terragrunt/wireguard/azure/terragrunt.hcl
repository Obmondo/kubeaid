remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = local.resource_group
    storage_account_name = local.storage_account
    container_name       = "${local.cluster_name}-terraform"
    key                  = "${path_relative_to_include()}/wireguard/terraform.tfstate"
  }
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}

locals {
  tags = {
    terraform = true
  }

  customer_vars = yamldecode(file(get_env("OBMONDO_VARS_FILE")))

  cluster_name = local.customer_vars.cluster_name

  resource_group  = local.customer_vars.resource_group
  storage_account = local.customer_vars.storage_account
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../../../terraform//azure/wireguard"

  after_hook "after_hook" {
    commands     = ["apply", "plan"]
    execute      = ["echo", "Please configure your wireguard client", "instruction given in readme file"]
    run_on_error = true
  }
}

inputs = merge(
  local.customer_vars,
)
