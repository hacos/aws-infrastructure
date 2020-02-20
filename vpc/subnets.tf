locals {
  main_cidr_block = "${lookup(var.workspace_to_main_subnet_map, terraform.workspace, "")}"
  cluster_primary_cidr_block = "${lookup(var.workspace_to_cluster_primary_subnet_map, terraform.workspace, "")}"
  cluster_secondary_cidr_block = "${lookup(var.workspace_to_cluster_secondary_subnet_map, terraform.workspace, "")}"
}

resource "aws_subnet" "main" {
  cidr_block        = local.main_cidr_block
  vpc_id            = aws_vpc.main.id

  tags = {
    environment = local.environment
  }
}

resource "aws_subnet" "cluster_primary" {
  cidr_block        = local.cluster_primary_cidr_block
  vpc_id            = aws_vpc.main.id

  tags = {
    environment = local.environment
  }
}

resource "aws_subnet" "cluster_secondary" {
  cidr_block        = local.cluster_secondary_cidr_block
  vpc_id            = aws_vpc.main.id

  tags = {
    environment = local.environment
  }
}
