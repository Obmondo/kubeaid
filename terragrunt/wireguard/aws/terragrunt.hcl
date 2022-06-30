remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "${local.cluster_name}-terraform"
    region  = "${local.region}"
    encrypt = true
    key     = "${path_relative_to_include()}/wireguard/terraform.tfstate"
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
  subdomain    = "${local.customer_vars.environment}.${local.customer_vars.domain_name}"
  region       = local.customer_vars.region
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../../../terraform//aws/wireguard"

  after_hook "after_hook" {
    commands     = ["apply", "plan"]
    execute      = ["echo", "Please configure your wireguard client", "instruction given in readme file"]
    run_on_error = true
  }
}

inputs = merge(
  local.customer_vars,
  {
    subdomain = local.subdomain,
  }
)
