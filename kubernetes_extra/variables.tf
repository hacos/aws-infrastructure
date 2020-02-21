# Globals
variable "prefix" {
  default = "eks"
}

variable "region" {
  default = "us-west-2"
}

variable "vpc_id" {}
variable "cluster_primary_subnet_id" {}
variable "cluster_secondary_subnet_id" {}

# Maps
variable "workspace_to_environment_map" {
  type = map(string)
  default = {
    staging    = "staging"
    production = "production"
  }
}

variable "workspace_to_root_domain_map" {
  type = map(string)
  default = {
    staging    = "hacphan.com"
    production = "hacphan.com"
  }
}
