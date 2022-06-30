data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "wireguard" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = tolist(module.vpc.public_subnets)[0]
  vpc_security_group_ids      = [aws_security_group.sg_wireguard.id]
  user_data                   = base64encode(templatefile("templates/cloud_init.yml.tftpl",
    {
      wg_address     = var.wg_cidr
      wg_port        = var.wg_server_port
      wg_peers       = var.wg_peers
      admin_ssh_keys = var.admin_ssh_keys
    }
  ))
  user_data_replace_on_change = false

  tags                   = {
    application = "wireguard"
    terraform   = true
    Name        = "wireguard-${var.subdomain}"
  }
}

resource "aws_security_group" "sg_wireguard" {
  name        = "wireguard"
  description = "Terraform Managed. Allow Wireguard client traffic from internet."
  vpc_id      = module.vpc.vpc_id

  tags = {
    terraform = true
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
