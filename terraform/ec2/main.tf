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
  depends_on = [aws_network_interface.base_interface]
  ami           = data.aws_ami.amazon-2.id
  instance_type = var.instance_size
  availability_zone = data.aws_availability_zone.az.name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  network_interface {
    network_interface_id = aws_network_interface.base_interface.id
    device_index         = 0
  }
  user_data = data.template_file.startup.rendered
  tags = local.tags
}

## Network logic from here on

resource "aws_network_interface" "base_interface" {
  subnet_id   = module.vpc.subnet_id_private
  tags = local.tags
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  depends_on = [module.vpc]
  network_interface_id = aws_network_interface.base_interface.id
  security_group_id    = module.vpc.sg_name
}

# EC2 -> Internet (for yum and SSM agent)
resource "aws_internet_gateway" "test_internet" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_route_table" "ec2_rt" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_internet.id
  }
  tags = local.tags
}

resource "aws_route_table" "ec2_rt_private" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ec2_nat_gateway.id
  }
  tags = local.tags
}

resource "aws_route_table_association" "ec2_internet" {
  subnet_id       = module.vpc.subnet_id_public
  route_table_id  = aws_route_table.ec2_rt.id
}

resource "aws_route_table_association" "ec2_internet_private" {
  subnet_id       = module.vpc.subnet_id_private
  route_table_id  = aws_route_table.ec2_rt_private.id
}

resource "aws_nat_gateway" "ec2_nat_gateway" {
  allocation_id = aws_eip.ec2.id
  subnet_id     = module.vpc.subnet_id_public
  tags = local.tags
}

resource "aws_eip" "ec2" {}