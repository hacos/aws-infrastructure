locals {
  main_cidr_block = "${lookup(var.workspace_to_main_subnet_map, terraform.workspace, "")}"
  cluster_cidr_block = "${lookup(var.workspace_to_cluster_subnet_map, terraform.workspace, "")}"
}

resource "aws_subnet" "main" {
  cidr_block        = local.main_cidr_block
  vpc_id            = aws_vpc.main.id

  tags = {
    environment = local.environment
  }
}

resource "aws_subnet" "cluster" {
  cidr_block        = local.cluster_cidr_block
  vpc_id            = aws_vpc.main.id

  tags = {
    environment = local.environment
  }
}
