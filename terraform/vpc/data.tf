data "aws_region" "current" {}
data "aws_availability_zone" "az" {
  name = "eu-west-1a"
}
data "aws_caller_identity" "current" {}
# For VPC tracing previously created
#data "aws_vpc" "test_vpc" {
#  id = "vpc-0b438d7b9fad4d41c"
#}
#data "aws_subnets" "example" {
#  filter {
#    name   = "vpc-id"
#    values = [data.aws_vpc.test_vpc.id]
#  }
#}
#
#data "aws_subnet" "subnet_test_vpc" {
#  id = data.aws_subnet.subnet_test_vpc.id
#}