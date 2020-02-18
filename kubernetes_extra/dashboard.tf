resource "helm_release" "dashboard" {
  namespace  = "kube-system"
  name       = "dashboard"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "kubernetes-dashboard"

  set {
    name  = "fullnameOverride"
    value = "kubernetes-dashboard"
  }

  set {
    name  = "enableSkipLogin"
    value = "true"
  }

  set {
    name  = "enableInsecureLogin"
    value = "true"
  }
}
resource "kubernetes_cluster_role_binding" "kubernetes_dashboard" {
  metadata {
    name      = "kubernetes-dashboard"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "kubernetes-dashboard"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
}
