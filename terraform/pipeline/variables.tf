variable "timeout" {
  default = "10"
}

# Used as work-around IAM limitations from V1 sandbox account / NOT RECOMMENDED IN PROD ENVS
variable "iam_super_power" {
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "permission_boundary" {
  default = "arn:aws:iam::783050088916:policy/UKDDCAWSRestrictedAdmin-PermBoundary"
}

variable "s3_artifactory" {
  default = "exercise-st-bucket"
}

variable "pipeline_list" {
  type = list(string)
  default = ["ec2", "ecr", "asg", "k8s"]
}

locals {
  tags = {
      Name = "internal_training_${terraform.workspace}"
      Owner = join("", [data.aws_caller_identity.current.id, "_", terraform.workspace])
  }
}