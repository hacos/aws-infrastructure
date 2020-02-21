resource "kubernetes_namespace" "airflow" {
  metadata {
    name = var.prefix
  }
}

resource "helm_release" "main" {
  namespace  = var.prefix
  name       = "${var.prefix}-${local.environment}"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = var.prefix

  # I couldn't figure out how to set the env JSON object here, so I had a file instead
  values = [
    templatefile("values.yaml", {
      ROOT_DOMAIN = local.root_domain
    })
  ]

  # set {
  #   name  = "persistence.uploads.existingClaim"
  #   value = kubernetes_persistent_volume_claim.uploads.metadata.0.name
  # }
  #
  # set {
  #   name  = "persistence.storage.existingClaim"
  #   value = kubernetes_persistent_volume_claim.storage.metadata.0.name
  # }
}

resource "kubernetes_ingress" "main" {
  metadata {
    namespace = var.prefix
    name      = "${var.prefix}-ingress"

    labels = {
      app      = "${var.prefix}-${local.environment}"
      chart    = "bookstack-1.2.0"
      heritage = "Helm"
      release  = "${var.prefix}-${local.environment}"
    }
  }

  spec {
    rule {
      host = "docs.${local.root_domain}"

      http {
        path {
          path = "/"

          backend {
            service_name = "${var.prefix}-${local.environment}"
            service_port = "80"
          }
        }
      }
    }
  }
}
