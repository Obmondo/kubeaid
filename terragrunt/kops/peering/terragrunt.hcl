include "root" {
  path = find_in_parent_folders()
}

skip = local.vars.locals.customer_vars.setup_peering == false ? true : false

terraform {
  source = "${get_parent_terragrunt_dir()}/../../terraform//aws/peering"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = "fake-kubernetes-vpc-id",
    vpc_cidr = "10.0.0.0/16"
    route_table_ids = [
      "rt-dummy-acceptor"
    ]
  }
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = merge(
  local.vars.locals.customer_vars,
  {
    acceptor_vpc_id        = dependency.vpc.outputs.vpc_id,
    acceptor_vpc_cidr      = dependency.vpc.outputs.cidr,
    acceptor_rt_table_ids  = dependency.vpc.outputs.route_table_ids
  },
)
