locals {
  tags = {
    Name   = "internal_training_${terraform.workspace}"
    Owner  = join("", [data.aws_caller_identity.current.id, "_", terraform.workspace])
    Delete = "true"
  }
}