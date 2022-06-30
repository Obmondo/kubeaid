data "aws_vpc" "from_vpc" {
  filter {
    name   = "tag:Name"
    values = ["wireguard"]
  }
}

# Add route entries, to all route tables in the DMZ cluster
data "aws_route_tables" "from_rt" {
  vpc_id = data.aws_vpc.from_vpc.id
}

resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = data.aws_vpc.from_vpc.id
  peer_vpc_id = var.acceptor_vpc_id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "requestor_route" {
  for_each                  = toset(data.aws_route_tables.from_rt.ids)
  route_table_id            = each.key
  destination_cidr_block    = var.acceptor_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "acceptor_route" {
  for_each                  = toset(var.acceptor_rt_table_ids)
  route_table_id            = each.key
  destination_cidr_block    = data.aws_vpc.from_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}
