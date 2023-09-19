##Creates a IAM role for EC2
resource "aws_iam_role" "ec2_role" {
  name                 = "ec2_${terraform.workspace}_role"
  permissions_boundary = var.permission_boundary
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = local.tags
}



# IAM policy for the role above
resource "aws_iam_policy" "ec2_policy" {
  policy = data.aws_iam_policy_document.ec2_p_document.json
  name   = "S3_${terraform.workspace}_policy"
}

# Generate the json blob for the policy above (S3 access for SSM session)
data "aws_iam_policy_document" "ec2_p_document" {
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

# Attach the policy to the role (adding SSM AWS role to allow SSM session)
resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  policy_arn = aws_iam_policy.ec2_policy.arn
  role       = aws_iam_role.ec2_role.name
}
resource "aws_iam_role_policy_attachment" "ec2_policy_attach_ssm" {
  policy_arn = var.ssm_policy
  role       = aws_iam_role.ec2_role.name
}

# Attach the role to the EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}