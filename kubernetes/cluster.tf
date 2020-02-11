resource "aws_iam_role" "cluster" {
  name               = "${var.prefix}-${local.environment}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role_policy.json

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

resource "aws_security_group" "main" {
  name        = "${var.prefix}-${local.environment}-security-group"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    environment = local.environment
  }
}

resource "aws_security_group_rule" "main" {
  cidr_blocks       = ["${chomp(data.http.ip.body)}/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.main.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "main" {
  name     = "${var.prefix}-${local.environment}"
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.main.id]
    subnet_ids         = [data.aws_subnet.main.id, data.aws_subnet.cluster.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}
