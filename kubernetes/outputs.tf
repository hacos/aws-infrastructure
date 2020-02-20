# Commands to set up kubectl
output "update" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${aws_eks_cluster.main.name}"
}

output "rename" {
  value = "kubectl config rename-context ${aws_eks_cluster.main.arn} ${aws_eks_cluster.main.name}"
}

output "delete" {
  value = "kubectl config delete-context ${aws_eks_cluster.main.name}"
}
