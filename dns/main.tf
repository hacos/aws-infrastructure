terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hacphan"

    workspaces {
      prefix = "aws-dns-"
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
