### BLOCKER DUE TO LACK OF PERMISSIONS IN THE V1 ACCOUNT
##Creates a IAM role for EC2
#resource "aws_iam_role" "ec2_role" {
#  name = "ec2_${terraform.workspace}_role"
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Action = "sts:AssumeRole"
#        Effect = "Allow"
#        Sid    = "sts_ec2"
#        Principal = {
#          Service = "ec2.amazonaws.com"
#        }
#      },
#    ]
#  })
#  tags = local.tags
#}
#


# IAM policy for the role above
resource "aws_iam_policy" "ec2_policy" {
  policy  = data.aws_iam_policy_document.ec2_p_document.json
  name = "test_policy"
}

# Generate the json blob for the policy above
data "aws_iam_policy_document" "ec2_p_document" {
statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  policy_arn = aws_iam_policy.ec2_policy.arn
  role       = var.iam_super_power
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attach_ssm" {
  policy_arn = var.ssm_policy
  role       = var.iam_super_power
}



# Attach the role to the EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = var.iam_super_power
}