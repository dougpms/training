# Include SG - If need amending, using locally as variable replacing the current in the child module. Examples commented out.
module "vpc" {
  source = "../vpc"
#  ingress_rules = {
#   type = map(object({
#    description = string
#    from_port   = number
#    to_port     = number
#    protocol    = string
#    cidr_blocks = list(string)
#  }))
#
#  default = {
#    tls_from_vpc = {
#      description      = "SSH to the box"
#      from_port        = 22
#      to_port          = 22
#      protocol         = "tcp"
#      cidr_blocks      = ["0.0.0.0/0"]
#    }
#    # Add more ingress rules as needed
#  }
#  }
}


# EC2 instance
resource "aws_instance" "base_instance" {
  ami           = data.aws_ami.amazon-2.name
  instance_type = var.instance_size

  network_interface {
    network_interface_id = aws_network_interface.base_interface.id
    device_index         = 0
  }
  tags = local.tags
}

resource "aws_network_interface" "base_interface" {
  subnet_id   = module.vpc.subnet_id
  tags = local.tags
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  network_interface_id = aws_network_interface.base_interface.id
  security_group_id    = module.vpc.sg_name
}