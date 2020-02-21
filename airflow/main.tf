terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hacphan"

    workspaces {
      prefix = "airflow-"
    }
  }
}

locals {
  environment = "${lookup(var.workspace_to_environment_map, terraform.workspace, "")}"
  root_domain = "${lookup(var.workspace_to_root_domain_map, terraform.workspace, "")}"
}

provider "aws" {
  profile    = local.environment
  region     = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.main.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.main.token
  }
}
