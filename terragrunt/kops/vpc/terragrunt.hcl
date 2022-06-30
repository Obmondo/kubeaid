include "root" {
  path = find_in_parent_folders()
}


# Use Terragrunt to download the module code
terraform {
  source = "${get_parent_terragrunt_dir()}/../../terraform//aws/vpc"
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = merge(
  local.vars.locals.customer_vars,
  {
    subdomain = local.vars.locals.subdomain
  }
)
