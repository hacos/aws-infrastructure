resource "null_resource" "wait_for_cluster" {
  depends_on = [
    aws_eks_cluster.main
  ]

  provisioner "local-exec" {
    command = var.wait_for_cluster_cmd
    environment = {
      ENDPOINT = aws_eks_cluster.main.endpoint
    }
  }
}

resource "kubernetes_config_map" "main" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<ROLES
- rolearn: ${aws_iam_role.workers.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
ROLES
}

  depends_on = [null_resource.wait_for_cluster]
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }

  depends_on = [null_resource.wait_for_cluster]
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  subject {
    kind      = "ServiceAccount"
    namespace = "kube-system"
    name      = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  depends_on = [null_resource.wait_for_cluster]
}
