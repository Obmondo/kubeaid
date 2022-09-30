resource "aws_s3_bucket" "kops_state" {
  bucket        = "${var.kops_state_bucket_name}"
  force_destroy = false

  tags = {
    "Environment"       = var.environment
    "KubernetesCluster" = var.cluster_name
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
