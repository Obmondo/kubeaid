resource "aws_vpc" "default" {
  cidr_block = local.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.default.id
  cidr_block = cidrsubnet(local.vpc_cidr, 1, 1)

  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  route_table_id = aws_route_table.public_subnet_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}
