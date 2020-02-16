terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hacphan"

    workspaces {
      prefix = "eks-"
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

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   load_config_file       = false
#   version                = "~> 1.9"
# }

module "main" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.prefix}-${local.environment}"
  cluster_version = "1.14"
  subnets         = [ data.aws_subnet.main.id, data.aws_subnet.cluster.id ]
  vpc_id          = data.aws_vpc.main.id

  worker_groups = [
    {
      instance_type = "t3.medium"
      asg_max_size  = 1
    }
  ]
}
