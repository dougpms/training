output "vpc_id" {
  value = aws_vpc.base_1.id
}
output "subnet_id_public" {
  value = aws_subnet.base_1_public.id
}

output "subnet_id_private" {
  value = aws_subnet.base_1_private.id
}



output "sg_name" {
  value = aws_security_group.sg_child.id
}