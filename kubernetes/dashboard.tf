# resource "helm_release" "metrics-server" {
#   name       = "metrics-server"
#   repository = data.helm_repository.stable.metadata[0].name
#   chart      = "metrics-server"
# }
#
# resource "helm_release" "dashboard" {
#   name       = "dashboard"
#   repository = data.helm_repository.stable.metadata[0].name
#   chart      = "kubernetes-dashboard"
#
#   set {
#     name  = "fullnameOverride"
#     value = "kubernetes-dashboard"
#   }
#
#   set {
#     name  = "enableSkipLogin"
#     value = "true"
#   }
#
#   set {
#     name  = "enableInsecureLogin"
#     value = "true"
#   }
# }

# Don't want to expose dashboard to world (unsafe). See https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca
# resource "kubernetes_service" "dashboard" {
#   metadata {
#     name = "dashboard-service"
#   }
#   spec {
#     selector = {
#       app  = "kubernetes-dashboard"
#       release = "${local.environment}"
#     }
#     port {
#       port        = 443
#       target_port = 8443
#     }
#     external_traffic_policy = "Cluster"
#     type = "LoadBalancer"
#   }
# }
