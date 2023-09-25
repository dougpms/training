variable "region_number" {
  # Arbitrary mapping of region name to number to use in
  # a VPC's CIDR prefix.
  default = {
    us-west-1 = 1
  }
}

variable "az_asg" {
  default = ["eu-west-1a"]

}

variable "az_number" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    a = 1
    b = 2
    c = 3
  }
}

# To be replaced if used as a submodule
variable "baseline_cidr" {
  default = "10.1.2.0/8"
}

variable "ingress_rules" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = {
    tls_from_vpc = {
      description = "SSH to the box"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    # Add more ingress rules as needed
  }
}

variable "egress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = {
    allow_all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    # Add more egress rules as needed
  }
}

variable "module_suffix" {
  default = ""
  description = "To be used in root modules and changing the naming for VPC"
}


locals {
  tags = {
    Name  = "internal_training_${terraform.workspace}${var.module_suffix}"
    Owner = join("", [data.aws_caller_identity.current.id, "_", terraform.workspace])
  }
  az_subnet_map = {
    for az in var.az_asg :
    az => cidrsubnet(aws_vpc.base_1.cidr_block, 6, index(var.az_asg, az))
  }

  az_subnet_map_pub = {
    for az in var.az_asg :
    az => cidrsubnet(aws_vpc.base_1.cidr_block, 4, index(var.az_asg, az) + 1)
  }
  az_asg = var.az_number == 0 ? data.aws_availability_zone.az.name : "eu-west-1a"
}