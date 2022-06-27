#  EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "QA-node" {
  name = "EKS-QA-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "QA-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.QA-node.name
}

resource "aws_iam_role_policy_attachment" "QA-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.QA-node.name
}

resource "aws_iam_role_policy_attachment" "QA-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.QA-node.name
}

resource "aws_eks_node_group" "QA" {
  cluster_name    = aws_eks_cluster.QA.name
  node_group_name = "QA-Node"
  node_role_arn   = aws_iam_role.demo-QA.arn
  subnet_ids      = aws_subnet.QA[*].id

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.QA-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.QA-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.QA-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
