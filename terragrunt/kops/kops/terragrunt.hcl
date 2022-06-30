include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../../terraform//aws/kops"
}

dependency "peering" {
  config_path = "../peering"

  skip_outputs = true
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id                  = "fake-vpc-id",
    cidr                    = "fake-cidr",
    private_subnets         = ["fake","dont","trust"]
    public_subnets          = ["fake","dont","trust"]
    availability_zone_names = ["fake-a", "fake-b", "fake-c"]
  }
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

inputs = merge(
  local.vars.locals.customer_vars,
  {
    subdomain               = local.vars.locals.subdomain,
    vpc_id                  = dependency.vpc.outputs.vpc_id,
    cidr                    = dependency.vpc.outputs.cidr,
    private_subnets         = dependency.vpc.outputs.private_subnets,
    public_subnets          = dependency.vpc.outputs.public_subnets,
    availability_zone_names = dependency.vpc.outputs.availability_zone_names,
  },
)
