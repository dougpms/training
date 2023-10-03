##Creates a IAM role for EC2
resource "aws_iam_role" "k8s_role" {
  name                 = "ec2_${terraform.workspace}_role${var.module_suffix}"
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
