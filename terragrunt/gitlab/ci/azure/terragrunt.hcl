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
    key                  = "${path_relative_to_include()}/gitlab-ci/terraform.tfstate"
  }
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "azurerm" {
  features {}
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
  source = "${get_parent_terragrunt_dir()}/../../../terraform//azure/gitlab-ci-server"
}

inputs = merge(
  local.customer_vars,
)
