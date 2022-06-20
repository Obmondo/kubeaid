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

resource "aws_route53_zone" "zone" {
  name    = local.subdomain
  comment = "Created on behalf of the ${var.cluster_name} Kubernetes cluster"
}

data "aws_instance" "wireguard" {
  filter {
    name   = "tag:Name"
    values = ["wireguard-${local.subdomain}"]
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

resource "aws_route53_record" "subzone-ns-records" {
  zone_id  = data.aws_route53_zone.parent_zone.zone_id
  name     = local.subdomain
  type     = "NS"
  ttl      = "300"
  records  = aws_route53_zone.zone.name_servers
}
