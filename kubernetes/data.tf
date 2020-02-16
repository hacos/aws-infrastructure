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

# data "aws_iam_policy_document" "cluster_assume_role_policy" {
#   statement {
#     sid = "EKSClusterAssumeRole"
#
#     actions = [
#       "sts:AssumeRole",
#     ]
#
#     principals {
#       type        = "Service"
#       identifiers = ["eks.amazonaws.com"]
#     }
#   }
# }
#
# data "aws_iam_policy_document" "node_assume_role_policy" {
#   statement {
#     sid = "EKSClusterAssumeRole"
#
#     actions = [
#       "sts:AssumeRole",
#     ]
#
#     principals {
#       type        = "Service"
#       identifiers = ["eks.amazonaws.com", "ec2.amazonaws.com"]
#     }
#   }
# }

data "aws_eks_cluster" "cluster" {
  name = module.main.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.main.cluster_id
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}
