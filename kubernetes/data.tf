data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnet" "main" {
  id = var.main_subnet_id
}

data "aws_subnet" "cluster" {
  id = var.cluster_subnet_id
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
