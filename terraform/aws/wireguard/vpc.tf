module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version = "3.14.0"

  name = "wireguard"
  cidr = "172.16.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["172.16.16.0/24"]
  public_subnets  = ["172.16.32.0/24"]


  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
}
