output "vpc_id" {
  value = aws_vpc.main.id
}

output "main_subnet_id" {
  value = aws_subnet.main.id
}

output "cluster_primary_subnet_id" {
  value = aws_subnet.cluster_primary.id
}

output "cluster_secondary_subnet_id" {
  value = aws_subnet.cluster_secondary.id
}
