remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "${local.bucket}"
    region  = "${local.region}"
    encrypt = true
    key     = "kops_bucket/terraform.tfstate"
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

skip = local.customer_vars.setup_kops_bucket == false ? true : false

terraform {
  source = "${get_parent_terragrunt_dir()}/../../../terraform//aws/kops_bucket"
}

locals {
   tags = {
    kops      = true
    terraform = true
  }

  customer_vars = yamldecode(file(get_env("OBMONDO_VARS_FILE")))

  cluster_name = local.customer_vars.cluster_name
  subdomain    = "${local.customer_vars.environment}.${local.customer_vars.domain_name}"
  region       = local.customer_vars.region
  bucket       = local.customer_vars.terraform_bucket
}

inputs = {
  kops_state_bucket_name = local.customer_vars.kops_state_bucket_name,
  cluster_name           = local.cluster_name,
  environment            = local.customer_vars.environment,
}
