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
      ROOT_DOMAIN       = local.root_domain,
      SENDGRID_API_KEY  = var.sendgrid_api_key,
      DATABASE_HOST     = aws_db_instance.main.address,
      DATABASE_USER     = var.prefix,
      DATABASE_PASSWORD = random_password.password.result,
      DATABASE_NAME     = var.prefix

      STORAGE_S3_KEY    = aws_iam_access_key.main.id
      STORAGE_S3_SECRET = aws_iam_access_key.main.secret
      STORAGE_S3_BUCKET = aws_s3_bucket.main.id
      STORAGE_S3_REGION = var.region
    })
  ]
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
