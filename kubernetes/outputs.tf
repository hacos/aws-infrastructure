# Commands to set up kubectl
output "update" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${data.aws_eks_cluster.main.name}"
}

output "rename" {
  value = "kubectl config rename-context ${data.aws_eks_cluster.main.arn} ${data.aws_eks_cluster.main.name}"
}

output "delete" {
  value = "kubectl config delete-context ${data.aws_eks_cluster.main.name}"
}
