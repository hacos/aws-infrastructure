data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnet" "cluster_primary" {
  id = var.cluster_primary_subnet_id
}

data "aws_subnet" "cluster_secondary" {
  id = var.cluster_secondary_subnet_id
}

data "http" "ip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
