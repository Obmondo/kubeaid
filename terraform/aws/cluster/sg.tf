resource "aws_security_group" "k8s_api_http" {
  name   = "${var.environment}_k8s_api_http"
  vpc_id = "${var.vpc_id}"
  tags   = "${var.tags}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.ingress_ips
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.ingress_ips
  }
}
