resource "helm_release" "manager" {
  namespace  = var.prefix
  name       = "${var.prefix}-manager-${local.environment}"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "${var.prefix}-manager"

  values = [
    templatefile("manager.yaml", {
      ENVIRONMENT = local.environment,
      ZKHOSTS     = "${data.kubernetes_service.zookeeper.metadata[0].name}:${data.kubernetes_service.zookeeper.spec[0].port[0].port}"
    })
  ]

  depends_on = [
    kubernetes_namespace.main,
    helm_release.kafka,
    data.kubernetes_service.zookeeper
  ]
}

resource "kubernetes_ingress" "manager" {
  metadata {
    namespace = var.prefix
    name      = "${var.prefix}-manager-ingress"

    labels = {
      app      = "${var.prefix}-${local.environment}"
      release  = "${var.prefix}-${local.environment}"
    }
  }

  spec {
    rule {
      host = "${var.prefix}-manager.${local.root_domain}"

      http {
        path {
          path = "/"

          backend {
            service_name = "${var.prefix}-manager-${local.environment}"
            service_port = data.kubernetes_service.manager.spec[0].port[0].port
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.main,
    helm_release.kafka,
    data.kubernetes_service.manager
  ]
}

resource "aws_route53_record" "manager" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.prefix}-manager.${local.root_domain}"
  type    = "A"

  alias {
    name                   = kubernetes_ingress.manager.load_balancer_ingress[0].hostname
    zone_id                = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = false
  }

  depends_on = [
    kubernetes_namespace.main,
    kubernetes_ingress.manager
  ]
}
