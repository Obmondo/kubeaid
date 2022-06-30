resource "aws_iam_policy" "kube2iam" {
  name        = "${var.environment}-kube2iam"
  path        = "/"
  description = "This is a policy made specifically for kube2iam, a system which grants roles to specific pods in Kubernetes."
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "kube2iam" {
  name               = "${var.environment}-kube2iam"
  path               = "/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
            "arn:aws:iam::${local.accountid}:role/nodes.${var.cluster_name}",
            "arn:aws:iam::${local.accountid}:role/masters.${var.cluster_name}"
          ]
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
            "arn:aws:iam::${local.accountid}:role/nodes.${var.cluster_name}",
            "arn:aws:iam::${local.accountid}:role/masters.${var.cluster_name}"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
