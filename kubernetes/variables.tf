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

# Used for aws_auth.tf
variable "wait_for_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT"
  type        = string
  default     = "until curl -k -s $ENDPOINT/healthz >/dev/null; do sleep 4; done"
}
