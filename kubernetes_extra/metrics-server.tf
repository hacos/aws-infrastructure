resource "helm_release" "metrics-server" {
  namespace  = "kube-system"
  name       = "metrics-server"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "metrics-server"
}
