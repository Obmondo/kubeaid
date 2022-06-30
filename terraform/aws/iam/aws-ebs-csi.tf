resource "aws_iam_role" "aws-ebs-csi" {
  name               = "${var.environment}-aws-ebs-csi"
  path               = "/"
  description        = "Allows aws-ebs-csi in the ${var.cluster_name} Kubernetes cluster, to manage EBS volumes"
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

resource "aws_iam_policy" "aws-ebs-csi" {
  name        = "${var.environment}-aws-ebs-csi"
  path        = "/"
  description = ""
  policy      = <<-EOF
  {
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DetachVolume",
          "ec2:ModifyVolume"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "aws-ebs-csi-attachment" {
  role       = aws_iam_role.aws-ebs-csi.name
  policy_arn = aws_iam_policy.aws-ebs-csi.arn
}
