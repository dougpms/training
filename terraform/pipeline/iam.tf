resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-terraform-role"
  permissions_boundary = var.permission_boundary
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# Adding super user (Not PRD friendly)
resource "aws_iam_role_policy_attachment" "ecr_policy_attach" {
  policy_arn = var.iam_super_power
  role       = aws_iam_role.codebuild_role.name
}