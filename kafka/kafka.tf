resource "kubernetes_namespace" "main" {
  metadata {
    name = var.prefix
  }
}

resource "helm_release" "kafka" {
  namespace  = var.prefix
  name       = "${var.prefix}-${local.environment}"
  repository = data.helm_repository.incubator.metadata[0].name
  chart      = var.prefix

  set {
    name  = "persistence.enabled"
    value = false
  }

  depends_on = [
    kubernetes_namespace.main,
  ]
}

# resource "kubernetes_ingress" "kafka" {
#   metadata {
#     namespace = var.prefix
#     name      = "${var.prefix}-ingress"
#
#     labels = {
#       app      = "${var.prefix}-${local.environment}"
#       release  = "${var.prefix}-${local.environment}"
#     }
#   }
#
#   spec {
#     rule {
#       host = "${var.prefix}.${local.root_domain}"
#
#       http {
#         path {
#           path = "/"
#
#           backend {
#             service_name = "${var.prefix}-${local.environment}"
#             service_port = data.kubernetes_service.kafka.spec[0].port[0].port
#           }
#         }
#       }
#     }
#   }
#
#   depends_on = [
#     kubernetes_namespace.main,
#     helm_release.kafka,
#     data.kubernetes_service.kafka
#   ]
# }
#
# resource "aws_route53_record" "kafka" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   name    = "${var.prefix}.${local.root_domain}"
#   type    = "A"
#
#   alias {
#     name                   = kubernetes_ingress.kafka.load_balancer_ingress[0].hostname
#     zone_id                = data.aws_elb_hosted_zone_id.main.id
#     evaluate_target_health = false
#   }
#
#   depends_on = [
#     kubernetes_namespace.main,
#     kubernetes_ingress.kafka
#   ]
# }
