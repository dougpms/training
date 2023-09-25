variable "instance_size" {
  default = "t2.micro"
}

variable "module_suffix" {
  default = "_asg_module"
}

variable "permission_boundary" {
  default = "arn:aws:iam::783050088916:policy/UKDDCAWSRestrictedAdmin-PermBoundary"
}

variable "ssm_policy" {
  default = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

locals {
  tags = {
    Name   = "internal_training_${terraform.workspace}${var.module_suffix}"
    Owner  = join("", [data.aws_caller_identity.current.id, "_", terraform.workspace])
    Delete = "true"
  }
}