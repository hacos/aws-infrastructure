resource "kubernetes_ingress" "main" {
  metadata {
    namespace = var.prefix
    name      = "${var.prefix}-ingress"

    labels = {
      app      = "${var.prefix}-${local.environment}"
      release  = "${var.prefix}-${local.environment}"
    }
  }

  spec {
    rule {
      host = "${var.prefix}.${local.root_domain}"

      http {
        path {
          path = "/"

          backend {
            service_name = "${var.prefix}-${local.environment}"
            service_port = random_integer.port.result
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.main,
    helm_release.main
  ]
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.prefix}.${local.root_domain}"
  type    = "A"

  alias {
    name                   = kubernetes_ingress.main.load_balancer_ingress[0].hostname
    zone_id                = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = false
  }

  depends_on = [
    kubernetes_namespace.main,
    kubernetes_ingress.main
  ]
}
