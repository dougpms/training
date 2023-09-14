variable "instance_size" {
  description = "Instance size"
  default = "t2.micro"
}

locals {
  tags = {
      Name = "internal_training_${terraform.workspace}"
      Owner = join("", [data.aws_caller_identity.current.id, "_", terraform.workspace])
  }
}