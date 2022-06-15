# Inspired from here
# https://www.perdian.de/blog/2021/12/27/setting-up-a-wireguard-vpn-at-aws-using-terraform/

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_subnets" "public_subnet_ids" {
  filter {
    name = "vpc-id"
    values = [module.vpc.vpc_id]
  }

  tags = {
    SubnetType = "Utility"
  }
}

data "template_file" "wireguard_userdata_peers" {
  template = file("templates/wireguard-user-data-peers.tpl")
  count = length(var.wg_peers)
  vars = {
    peer_name        = var.wg_peers[count.index].name
    peer_public_key  = var.wg_peers[count.index].public_key
    peer_allowed_ips = var.wg_peers[count.index].allowed_ips
  }
}

data "template_file" "wireguard_userdata" {
  template = file("templates/wireguard-user-data.tpl")
  vars = {
    client_network_cidr   = var.wg_cidr
    wg_server_private_key = var.wg_server_private_key
    wg_server_public_key  = var.wg_server_public_key
    wg_server_port        = var.wg_server_port
    wg_peers              = join("\n", data.template_file.wireguard_userdata_peers.*.rendered)
  }
}

resource "aws_instance" "wireguard" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.nano"
  subnet_id              = tolist(data.aws_subnets.public_subnet_ids.ids)[0]
  vpc_security_group_ids = [aws_security_group.sg_wireguard.id]
  user_data              = data.template_file.wireguard_userdata.rendered
  tags                   = {
    Name = "wireguard-${local.subdomain}"
  }
}

resource "aws_security_group" "sg_wireguard" {
  name        = "wireguard-${var.environment}-${var.region}"
  description = "Terraform Managed. Allow Wireguard client traffic from internet."
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name       = "wireguard-${var.environment}-${var.region}"
    Project    = "wireguard"
    tf-managed = "True"
    env        = var.environment
  }

  ingress {
    from_port   = var.wg_server_port
    to_port     = var.wg_server_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
