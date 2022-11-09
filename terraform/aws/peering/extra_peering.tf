data "aws_vpc" "from_vpc" {
  for_each    = var.peerings
  name        = each.key
  filter {
    name   = "tag:Name"
    values = [each.value.requestor_tag]
  }
}

data "aws_vpc" "to_vpc" {
  for_each    = var.peerings
  name        = each.key
  filter {
    name   = "tag:Name"
    values = [each.value.acceptor_tag]
  }
}

resource "aws_vpc_peering_connection" "peerings" {
  for_each    = var.peerings
  name        = each.key
  vpc_id      = data.aws_vpc.from_vpc[each.key].id
  peer_vpc_id = data.aws_vpc.to_vpc[each.key].id
  auto_accept = true
}

resource "aws_vpc_peering_connection_options" "peerings" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peerings[each.key].id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_vpc_to_remote_classic_link = true
    allow_classic_link_to_remote_vpc = true
  }
}
