variable "from_vpc" {}
variable "to_vpc" {}

data "aws_vpc" "from_vpc" {
  filter {
    name   = "tag:Name"
    values = [ var.from_vpc ]
  }
}
data "aws_vpc" "to_vpc" {
  filter {
    name   = "tag:Name"
    values = [ var.to_vpc ]
  }
}

resource "aws_vpc_peering_connection" "peering" {
  vpc_id        = data.aws_vpc.from_vpc.id
  peer_vpc_id   = data.aws_vpc.to_vpc.id
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

data "aws_route_tables" "from_rt" {
  vpc_id = data.aws_vpc.from_vpc.id
}
resource "aws_route" "from_route" {
  for_each                  = toset( data.aws_route_tables.from_rt.ids )
  route_table_id            = each.key
  destination_cidr_block    = data.aws_vpc.to_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

data "aws_route_tables" "to_rt" {
  vpc_id = data.aws_vpc.to_vpc.id
}
resource "aws_route" "prod-dmz" {
  for_each                  = toset( data.aws_route_tables.to_rt.ids )
  route_table_id            = each.key
  destination_cidr_block    = data.aws_vpc.from_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

output "peering_status" {
  value = {
    from_vpc: var.from_vpc
    to_vpc: var.to_vpc
    status: aws_vpc_peering_connection.peering.accept_status
  }
}
