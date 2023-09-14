output "vpc_id" {
  value = aws_vpc.base_1.id
}
output "subnet_id" {
  value = aws_subnet.base_1.id
}

output "sg_name" {
  value = aws_security_group.sg_child.name
}