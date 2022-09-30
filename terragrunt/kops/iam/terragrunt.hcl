include "root" {
  path = find_in_parent_folders()
}


# Use Terragrunt to download the module code
terraform {
  source = "${get_parent_terragrunt_dir()}/../../terraform//aws/iam"
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    subzone_id = "fake-subzone-id"
  }
}

dependencies {
  paths = ["../vpc", "../cluster"]
}

inputs = merge(
  local.vars.locals.customer_vars,
  {
    subzone_id   = dependency.vpc.outputs.subzone_id
  }
)
