locals {
  tags = {
    name      = var.cluster_name
    env       = var.environment
    terraform = true
  }

  subdomain = "${var.environment}.${var.domain_name}"

  accountid = data.aws_caller_identity.current.account_id
}
