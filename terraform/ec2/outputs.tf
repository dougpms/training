output "ec2_name" {
  value = aws_instance.base_instance.id
}
output "external_nat_ip" {
  value = aws_eip.ec2.public_ip
}
