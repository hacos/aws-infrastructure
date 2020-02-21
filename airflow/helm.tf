resource "kubernetes_namespace" "main" {
  metadata {
    name = var.prefix
  }
}

resource "helm_release" "main" {
  namespace  = var.prefix
  name       = var.prefix
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "airflow"
  timeout    = 600

  set {
    name  = "web.baseUrl"
    value = "https://airflow.${local.root_domain}"
  }
}

resource "kubernetes_ingress" "main" {
  metadata {
    namespace  = var.prefix
    name       = "${var.prefix}-ingress"

    labels = {
      app      = "airflow"
      chart    = "airflow-6.0.2"
      heritage = "Helm"
      release  = "airflow"
    }
  }

  spec {
    rule {
      host = "airflow.${local.root_domain}"
      http {
        path {
          backend {
            service_name = "airflow-web"
            service_port = "8080"
          }
        }
      }
    }
  }
}
