resource "helm_release" "ingress" {
  namespace  = "kube-system"
  name       = "${var.prefix}-ingress"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "nginx-ingress"

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  values = [
    templatefile("ingress.yaml", {
      CERT_ARN = data.aws_acm_certificate.main.arn
    })
  ]
}
