output "vpc_id" {
  value = aws_vpc.main.id
}

output "main_subnet_id" {
  value = aws_subnet.main.id
}

output "cluster_subnet_id" {
  value = aws_subnet.cluster.id
}
