# Globals
variable "prefix" {
  default = "eks"
}

variable "region" {
  default = "us-west-2"
}

variable "vpc_id" {}
variable "main_subnet_id" {}
variable "cluster_subnet_id" {}

# Maps
variable "workspace_to_environment_map" {
  type = map(string)
  default = {
    staging    = "staging"
    production = "production"
  }
}
