variable "instance_size" {
  default = "t2.micro"
}

variable "module_suffix" {
  default = "_k8s_module"
}

variable "permission_boundary" {
  default = "arn:aws:iam::783050088916:policy/UKDDCAWSRestrictedAdmin-PermBoundary"
}

variable "ssm_policy" {
  default = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

variable "admin_policy" {
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "ec2_policy" {
  default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

variable "worker_node" {
  default = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

variable "iam_policy_boundary" {
  type    = map(string)
  default = {
    "policy_arn" = "arn:aws:iam::783050088916:policy/UKDDCAWSRestrictedAdmin-PermBoundary"
  }
}

locals {
  tags = {
    Name   = "internal_training_${terraform.workspace}${var.module_suffix}"
    Owner  = join("", [data.aws_caller_identity.current.id, "_", terraform.workspace])
    Delete = "true"
  }
}