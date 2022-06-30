resource "aws_iam_role" "cluster-autoscaler" {
  name               = "${var.environment}-cluster-autoscaler"
  path               = "/"
  description        = "This allows the cluster-autoscaler on the ${var.cluster_name} cluster to manage it's autoscaling groups"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
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
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "cluster-autoscaler" {
  name        = "${var.environment}-cluster-autoscaler"
  path        = "/"
  description = "This policy is required by the cluster autoscaler in the ${var.cluster_name} k8s cluster"
  policy      = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ],
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "autoscaling:ResourceTag/KubernetesCluster": "${var.cluster_name}"
          }
        }
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "cluster-autoscaler-attachment" {
  role       = aws_iam_role.cluster-autoscaler.name
  policy_arn = aws_iam_policy.cluster-autoscaler.arn
}
