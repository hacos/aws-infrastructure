resource "aws_iam_role" "cluster" {
  name                  = "${var.prefix}-${local.environment}-iam-role-cluster"
  assume_role_policy    = data.aws_iam_policy_document.cluster_assume_role_policy.json
  force_detach_policies = true

  tags = {
    environment = local.environment
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_security_group" "cluster" {
  name        = "${var.prefix}-${local.environment}-security-group"
  description = "EKS cluster security group"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    environment = local.environment
  }
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  description              = "Allow cluster egress access to the Internet"
  protocol                 = "-1"
  security_group_id        = aws_security_group.cluster.id
  cidr_blocks              = ["0.0.0.0/0"]
  from_port                = 0
  to_port                  = 0
  type                     = "egress"
}

resource "aws_security_group_rule" "cluster_https_worker_ingress" {
  description              = "Allow pods to communicate with the EKS cluster API"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.workers.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_https_workstation_ingress" {
  cidr_blocks              = ["${chomp(data.http.ip.body)}/32"]
  description              = "Allow workstation to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_eks_cluster" "main" {
  name     = "${var.prefix}-${local.environment}"
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.cluster.id]
    subnet_ids         = [data.aws_subnet.cluster_primary.id, data.aws_subnet.cluster_secondary.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}
