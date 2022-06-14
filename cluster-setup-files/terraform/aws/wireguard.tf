# Inspired from here
# https://github.com/vainkop/terraform-aws-wireguard

data "template_file" "wg_client_data_json" {
  template = file("${path.module}/templates/client-data.tpl")
  count    = length(var.wg_clients)

  vars = {
    friendly_name        = var.wg_clients[count.index].friendly_name
    client_pub_key       = var.wg_clients[count.index].public_key
    client_ip            = var.wg_clients[count.index].client_ip
    persistent_keepalive = var.wg_persistent_keepalive
  }
}

resource "aws_launch_configuration" "wireguard_launch_config" {
  name_prefix          = "wireguard-${var.env}-${var.region}-"
  image_id             = var.bastion.image_id
  instance_type        = var.bastion.instance_type
  security_groups      = [aws_security_group.sg_wireguard.id]
  key_name             = file("./ssh_pub.key")
  user_data = templatefile("${path.module}/templates/user-data.txt", {
    wg_server_private_key = var.wg_server_private_key,
    wg_server_net         = var.cidr,
    wg_server_port        = var.wg_server_port,
    peers                 = join("\n", data.template_file.wg_client_data_json.*.rendered),
    wg_server_interface   = "eth0"
  })

  lifecycle {
    create_before_destroy = true
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
