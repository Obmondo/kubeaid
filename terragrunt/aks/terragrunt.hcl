remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = local.resource_group
    storage_account_name = local.storage_account
    container_name       = local.container
    key                  = "${path_relative_to_include()}/aks/terraform.tfstate"
  }
}

locals {
  tags = {
    terraform = true
  }

  customer_vars   = yamldecode(file(get_env("OBMONDO_VARS_FILE")))

  cluster_name    = local.customer_vars.cluster_name
  container       = local.customer_vars.container
  resource_group  = local.customer_vars.resource_group
  storage_account = local.customer_vars.storage_account
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../../terraform//azure/aks"

  after_hook "after_hook" {
    commands     = ["apply", "plan"]
    execute      = ["echo", "Your Azure Kubernetes managed is setup"]
    run_on_error = false
  }
}

inputs = merge(
  local.customer_vars,
)
