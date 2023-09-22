# Retrieve the AZ where we want to create network resources
# This must be in the region selected on the AWS provider.


# Create a VPC for the region associated with the AZ
resource "aws_vpc" "base_1" {
  cidr_block           = cidrsubnet(var.baseline_cidr, 8, 1)
  enable_dns_hostnames = "true"
  tags                 = local.tags
}

# Create a subnet for the AZ within the regional VPC
resource "aws_subnet" "base_1_private" {
  count             = length(var.az_asg)
  vpc_id            = aws_vpc.base_1.id
  availability_zone = var.az_asg[count.index]
  cidr_block        = local.az_subnet_map[var.az_asg[count.index]]
  tags              = local.tags
}

resource "aws_subnet" "base_1_public" {
  count             = length(var.az_asg)
  vpc_id            = aws_vpc.base_1.id
  availability_zone = var.az_asg[count.index]
  cidr_block        = local.az_subnet_map_pub[var.az_asg[count.index]]
  tags              = local.tags
}