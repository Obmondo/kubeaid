data "aws_route53_zone" "parent_zone" {
  name = var.domain_name
}

resource "aws_route53_zone" "zone" {
  name    = var.subdomain
  comment = "Created on behalf of the ${var.cluster_name} Kubernetes cluster"
}

resource "aws_route53_record" "subzone-ns-records" {
  zone_id  = data.aws_route53_zone.parent_zone.zone_id
  name     = var.subdomain
  type     = "NS"
  ttl      = "300"
  records  = aws_route53_zone.zone.name_servers
}
