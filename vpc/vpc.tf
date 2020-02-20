locals {
  vpc_cidr_block = "${lookup(var.workspace_to_vpc_map, terraform.workspace, "")}"
}

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr_block

  tags = {
    environment = local.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    environment = local.environment
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    environment = local.environment
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "cluster_primary" {
  subnet_id      = aws_subnet.cluster_primary.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "cluster_secondary" {
  subnet_id      = aws_subnet.cluster_secondary.id
  route_table_id = aws_route_table.main.id
}
