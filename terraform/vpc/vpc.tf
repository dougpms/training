# Retrieve the AZ where we want to create network resources
# This must be in the region selected on the AWS provider.


# Create a VPC for the region associated with the AZ
resource "aws_vpc" "base_1" {
  cidr_block = cidrsubnet(var.baseline_cidr, 8, 1)
  enable_dns_hostnames = "true"
  tags = local.tags
}

# Create a subnet for the AZ within the regional VPC
resource "aws_subnet" "base_1_private" {
  vpc_id     = aws_vpc.base_1.id
  availability_zone = data.aws_availability_zone.az.name
  cidr_block = cidrsubnet(aws_vpc.base_1.cidr_block, 4, var.az_number[data.aws_availability_zone.az.name_suffix])
  tags = local.tags
}

resource "aws_subnet" "base_1_public" {
  vpc_id     = aws_vpc.base_1.id
  availability_zone = data.aws_availability_zone.az.name
  cidr_block = cidrsubnet(aws_vpc.base_1.cidr_block, 2, var.az_number[data.aws_availability_zone.az.name_suffix])
  tags = local.tags
}