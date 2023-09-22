# Disabled until testing phase completed
module "vpc" {
  source = "../vpc"

}

#module "ec2" {
#  source = "../ec2"
#  instance_numbers = "1"
#}

resource "aws_launch_configuration" "asg_launch_config" {
  image_id      = data.aws_ami.amazon-2.id
  instance_type = var.instace_size
}

resource "aws_autoscaling_group" "asg_ec2_exercise" {
  name                 = "asg-ec2-${terraform.workspace}"
  vpc_zone_identifier  = [module.vpc.subnet_id_private]
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.asg_launch_config.name
  target_group_arns    = [aws_lb_target_group.lb_ec2_tg.arn]
}