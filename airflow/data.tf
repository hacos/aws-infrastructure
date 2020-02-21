data "aws_eks_cluster" "main" {
  name = "eks-${local.environment}"
}

data "aws_eks_cluster_auth" "main" {
  name = "eks-${local.environment}"
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "helm_repository" "incubator" {
  name = "incubator"
  url  = "http://storage.googleapis.com/kubernetes-charts-incubator"
}

data "aws_acm_certificate" "main" {
  domain   = "*.${local.root_domain}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "main" {
  name         = local.root_domain
  private_zone = false
}
