resource "aws_eip" "wireguard" {
  vpc      = true
  instance = aws_instance.wireguard.id

  tags = {
    Name = "wireguard"
  }
}

data "aws_route53_zone" "parent_zone" {
  name = var.domain_name
}

data "aws_instance" "wireguard" {
  filter {
    name   = "tag:Name"
    values = ["wireguard-${var.subdomain}"]
  }

  instance_id = aws_instance.wireguard.id
}

resource "aws_route53_record" "wireguard-A-record" {
  zone_id = data.aws_route53_zone.parent_zone.zone_id
  name    = "wg.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.wireguard.public_ip]
  depends_on = [
    aws_instance.wireguard
  ]
}
