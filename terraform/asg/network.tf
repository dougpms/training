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
  for_each = { for idx, _ in module.vpc.subnet_id_private : idx => null }
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ec2_nat_gateway[each.key].id
  }
  tags = local.tags
}

resource "aws_route_table_association" "ec2_internet" {
  for_each = { for idx, subnet_id in module.vpc.subnet_id_public : idx => subnet_id }
  subnet_id      = each.value
  route_table_id = aws_route_table.ec2_rt.id
}

resource "aws_route_table_association" "ec2_internet_private" {
  for_each = { for idx, subnet_id in module.vpc.subnet_id_private : idx => subnet_id }
  subnet_id      = each.value
  route_table_id = aws_route_table.ec2_rt_private[each.key].id
}

resource "aws_nat_gateway" "ec2_nat_gateway" {
  for_each = { for idx, subnet_id in module.vpc.subnet_id_public : idx => subnet_id }
  allocation_id = aws_eip.ec2[each.key].id
  subnet_id     = each.value
  tags          = local.tags
}

resource "aws_eip" "ec2" {
  for_each = { for idx, subnet_id in module.vpc.subnet_id_public : idx => subnet_id }
}