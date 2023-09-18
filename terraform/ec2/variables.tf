variable "instance_size" {
  description = "Instance size"
  default = "t2.micro"
}

variable "instance_numbers" {
  default = "3"
}

variable "ebs_size" {
  description = "EBS size"
  default = "40"
}

variable "ebs_encrypted" {
  default = "false"
}

# Used as work-around IAM limitations from V1 sandbox account / NOT RECOMMENDED IN PROD ENVS
variable "iam_super_power" {
  default = "AWSRDSCustomCloudWatchRole"
}

variable "permission_boundary" {
  default = "arn:aws:iam::783050088916:policy/UKDDCAWSRestrictedAdmin-PermBoundary"
}

variable "ssm_policy" {
  default = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

locals {
  tags = {
      Name = "internal_training_${terraform.workspace}"
      Owner = join("", [data.aws_caller_identity.current.id, "_", terraform.workspace])
  }
}