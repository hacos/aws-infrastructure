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

data "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

data "aws_acm_certificate" "main" {
  domain   = "*.${local.root_domain}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "main" {
  name         = local.root_domain
  private_zone = false
}

data "aws_elb_hosted_zone_id" "main" {}

data "kubernetes_service" "kafka" {
  metadata {
    namespace = var.prefix
    name      =  "${var.prefix}-${local.environment}"
  }

  depends_on = [
    helm_release.kafka,
  ]
}

data "kubernetes_service" "manager" {
  metadata {
    namespace = var.prefix
    name      =  "${var.prefix}-manager-${local.environment}"
  }

  depends_on = [
    kubernetes_namespace.main,
    helm_release.manager
  ]
}

data "kubernetes_service" "zookeeper" {
  metadata {
    namespace = var.prefix
    name      =  "${var.prefix}-${local.environment}-zookeeper"
  }

  depends_on = [
    helm_release.kafka,
  ]
}
