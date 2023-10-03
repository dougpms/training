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
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = local.tags
}



# IAM policy for the role above
resource "aws_iam_policy" "k8s_policy" {
  policy = data.aws_iam_policy_document.k8s_p_document.json
  name   = "S3_${terraform.workspace}${var.module_suffix}_policy"
}

# Generate the json blob for the policy above (S3 access for SSM session)
data "aws_iam_policy_document" "k8s_p_document" {
  statement {
    sid = "1"

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}
