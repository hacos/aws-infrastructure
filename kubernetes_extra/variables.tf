# Globals
variable "prefix" {
  default = "eks"
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
