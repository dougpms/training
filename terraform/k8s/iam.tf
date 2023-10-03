##Creates a IAM role for K8s
resource "aws_iam_role" "k8s_role" {
  name                 = "k8s_${terraform.workspace}_role${var.module_suffix}"
  permissions_boundary = var.permission_boundary
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]
        }
      },
    ]
  })
  tags = local.tags
}



# IAM policy for the role above
resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.k8s_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "admin_policy_attach" {
  policy_arn = var.admin_policy
  role       = aws_iam_role.k8s_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  policy_arn = var.ec2_policy
  role       = aws_iam_role.k8s_role.name
}



##Creates a IAM role for EC2
resource "aws_iam_role" "node_role" {
  name                 = "node_${terraform.workspace}_role${var.module_suffix}"
  permissions_boundary = var.permission_boundary
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]
        }
      },
    ]
  })
  tags = local.tags
}



# IAM policy for the role above
resource "aws_iam_role_policy_attachment" "node_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attach_node" {
  policy_arn = var.ec2_policy
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_policy_attach_node" {
  policy_arn = var.worker_node
  role       = aws_iam_role.node_role.name
}
