  resource "aws_iam_role" "QA-cluster" {
  name = "EKS-QA-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "QA-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.QA-cluster.name
}

resource "aws_iam_role_policy_attachment" "QA-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.QA-cluster.name
}

resource "aws_security_group" "QA-cluster" {
  name        = "terraform-eks-QA-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.QA.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS_QA"
  }
}

resource "aws_security_group_rule" "QA-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.QA-cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "QA" {
  name     = var.cluster-name
  role_arn = aws_iam_role.QA-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.QA-cluster.id]
    subnet_ids         = aws_subnet.QA[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.QA-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.QA-cluster-AmazonEKSVPCResourceController,
  ]
}
