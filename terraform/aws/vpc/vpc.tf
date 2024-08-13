module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version = "5.12.1"

  name = var.cluster_name
  cidr = var.cidr

  azs             = var.availability_zone_names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  tags = {
    environment = var.environment
    application = "network"
    terraform   = true
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
