# Globals
variable "prefix" {
  default = "vpc"
}

variable "region" {
  default = "us-west-2"
}

# Maps
variable "workspace_to_environment_map" {
  type = map(string)
  default = {
    staging    = "staging"
    production = "production"
  }
}

# CIDR Blocks
variable "workspace_to_vpc_map" {
  type = map(string)
  default = {
    staging    = "172.16.0.0/16"
    production = "10.0.0.0/8"
  }
}

variable "workspace_to_main_subnet_map" {
  type = map(string)
  default = {
    staging    = "172.16.1.0/24"
    production = "10.1.0.0/16"
  }
}

variable "workspace_to_cluster_primary_subnet_map" {
  type = map(string)
  default = {
    staging    = "172.16.2.0/24"
    production = "10.2.0.0/16"
  }
}

variable "workspace_to_cluster_secondary_subnet_map" {
  type = map(string)
  default = {
    staging    = "172.16.3.0/24"
    production = "10.3.0.0/16"
  }
}
