resource "kubernetes_namespace" "main" {
  metadata {
    name = var.prefix
  }
}

resource "random_integer" "port" {
  min     = 8000
  max     = 9999
}

resource "random_password" "password" {
  length = 16
  special = false
}

resource "helm_release" "main" {
  namespace  = var.prefix
  name       = "${var.prefix}-${local.environment}"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = var.prefix

  set {
    name  = "master.servicePort"
    value = random_integer.port.result
  }

  set {
    name  = "master.adminPassword"
    value = random_password.password.result
  }

  set {
    name  = "master.jenkinsUrlProtocol"
    value = "https"
  }
}
