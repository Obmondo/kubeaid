locals {
  tags = {
    name      = var.cluster_name
    env       = var.environment
    terraform = true
  }

  subdomain = "${var.environment}.${var.domain_name}"
}
