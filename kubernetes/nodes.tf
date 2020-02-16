# resource "aws_iam_role" "node" {
#   name               = "${var.prefix}-${local.environment}-iam-role-node"
#   assume_role_policy = data.aws_iam_policy_document.node_assume_role_policy.json
#
#   tags = {
#     environment = local.environment
#   }
# }
#
# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.node.name
# }
#
# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.node.name
# }
#
# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.node.name
# }
#
# resource "aws_security_group" "node" {
#   name        = "${var.prefix}-security-group-node"
#   description = "Security group for all nodes in the cluster"
#   vpc_id      = data.aws_vpc.main.id
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     environment = local.environment
#   }
# }
#
#
# resource "aws_security_group_rule" "node-ingress-self" {
#   description              = "Allow node to communicate with each other"
#   from_port                = 0
#   protocol                 = "-1"
#   security_group_id        = aws_security_group.node.id
#   source_security_group_id = aws_security_group.node.id
#   to_port                  = 65535
#   type                     = "ingress"
# }
#
# resource "aws_security_group_rule" "node-ingress-cluster" {
#   description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#   from_port                = 1025
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.node.id
#   source_security_group_id = aws_security_group.cluster.id
#   to_port                  = 65535
#   type                     = "ingress"
# }
#
# resource "aws_security_group_rule" "cluster-ingress-node-https" {
#   description              = "Allow pods to communicate with the cluster API Server"
#   from_port                = 443
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.cluster.id
#   source_security_group_id = aws_security_group.node.id
#   to_port                  = 443
#   type                     = "ingress"
# }
#
# resource "aws_eks_node_group" "primary" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = "primary"
#   node_role_arn   = aws_iam_role.node.arn
#   subnet_ids      = [data.aws_subnet.main.id, data.aws_subnet.cluster.id]
#
#   scaling_config {
#     desired_size = 1
#     max_size     = 1
#     min_size     = 1
#   }
#
#   depends_on = [
#     aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
#   ]
# }
