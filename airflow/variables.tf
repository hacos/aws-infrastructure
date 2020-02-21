variable "prefix" {
  default = "airflow"
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

variable "workspace_to_root_domain_map" {
  type = map(string)
  default = {
    staging    = "hacphan.com"
    production = "hacphan.com"
  }
}
