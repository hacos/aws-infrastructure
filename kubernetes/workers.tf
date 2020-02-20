resource "aws_iam_role" "workers" {
  name                  = "${var.prefix}-${local.environment}-iam-role-workers"
  assume_role_policy    = data.aws_iam_policy_document.workers_assume_role_policy.json
  force_detach_policies = true

  tags = {
    environment = local.environment
  }
}

resource "aws_iam_instance_profile" "workers" {
  name_prefix = "${var.prefix}-${local.environment}-iam-instance-profile-workers"
  role = aws_iam_role.workers.id
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workers.name
}

resource "aws_security_group" "workers" {
  name        = "${var.prefix}-security-group-workers"
  description = "Security group for all nodes in the cluster"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    environment = local.environment
  }
}

resource "aws_security_group_rule" "workers_egress_internet" {
  description              = "Allow nodes all egress to the Internet"
  protocol                 = "-1"
  security_group_id        = aws_security_group.workers.id
  cidr_blocks              = ["0.0.0.0/0"]
  from_port                = 0
  to_port                  = 0
  type                     = "egress"
}

resource "aws_security_group_rule" "workers_ingress_self" {
  description              = "Allow node to communicate with each other"
  protocol                 = "-1"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.workers.id
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster" {
  description              = "Allow workers pods to receive communication from the cluster control plane"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 1025
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_kubelet" {
  description              = "Allow workers Kubelets to receive communication from the cluster control plane"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_https" {
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_eks_node_group" "primary" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "primary"
  node_role_arn   = aws_iam_role.workers.arn
  subnet_ids      = [data.aws_subnet.cluster_primary.id, data.aws_subnet.cluster_secondary.id]

  scaling_config {
    desired_size  = 1
    max_size      = 1
    min_size      = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
