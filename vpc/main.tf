terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hacphan"

    workspaces {
      prefix = "vpc-"
    }
  }
}

locals {
  environment = "${lookup(var.workspace_to_environment_map, terraform.workspace, "")}"
}

provider "aws" {
  profile    = local.environment
  region     = var.region
}
