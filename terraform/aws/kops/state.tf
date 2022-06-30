resource "aws_s3_bucket" "kops_state" {
  bucket        = "${var.kops_state_bucket_name}"
  force_destroy = false

  tags = {
    Environment = var.environment
    Application = "kops"
  }
}

resource "aws_s3_bucket_versioning" "kops_state_bucket_versioning" {
  bucket = aws_s3_bucket.kops_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "kops_state_bucket_acl" {
  bucket = aws_s3_bucket.kops_state.id
  acl    = "private"
}

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
