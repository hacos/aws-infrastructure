resource "helm_release" "ingress" {
  name       = "${var.prefix}-ingress"
  repository = "stable"
  chart      = "nginx-ingress"

  set {
    name  = "controller.service.enabled"
    value = "true"
  }

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }
}

# resource "kubernetes_secret" "tls" {
#   metadata {
#     name = "${var.prefix}-tls"
#   }
#
#   data = {
#     "tls.crt" = data.template_file.crt.rendered
#     "tls.key" = data.template_file.key.rendered
#   }
#
#   type = "kubernetes.io/tls"
# }
#
# data "template_file" "crt" {
#   template = file("./certs/${local.environment}/tls.crt")
# }
#
# data "template_file" "key" {
#   template = file("./certs/${local.environment}/tls.key")
# }
