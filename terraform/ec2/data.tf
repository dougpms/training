data "aws_region" "current" {}
data "aws_availability_zone" "az" {
  name = "eu-west-1a"
}
data "aws_caller_identity" "current" {}

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}


data "template_file" "startup" {
 template = file("${path.module}/scripts/ssm_agent.sh")
}