data "aws_eks_cluster" "main" {
  name = "${var.prefix}-${local.environment}"
}

data "aws_eks_cluster_auth" "main" {
  name = "${var.prefix}-${local.environment}"
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}
