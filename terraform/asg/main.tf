# Disabled until testing phase completed
module "vpc" {
  source = "../vpc"
# Limited to 2 AZ in this case due to External IP  needed in the code
  az_asg = ["eu-west-1a", "eu-west-1b"]
  module_suffix = "_asg_module"

}

#module "ec2" {
#  source = "../ec2"
#  instance_numbers = "1"
#}

resource "aws_launch_configuration" "asg_launch_config" {
  image_id      = data.aws_ami.amazon-2.id
  instance_type = var.instance_size
  security_groups             = [module.vpc.sg_name]
  user_data = data.template_file.startup.rendered
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}

resource "aws_autoscaling_group" "asg_ec2_exercise" {
  name                 = "asg-ec2-${terraform.workspace}"
  vpc_zone_identifier  = module.vpc.subnet_id_private
  min_size             = 1
  max_size             = 3
  desired_capacity     = 3
  launch_configuration = aws_launch_configuration.asg_launch_config.name
  target_group_arns    = [aws_lb_target_group.lb_ec2_tg.arn]
  health_check_type     = "EC2"
  instance_refresh {
    strategy = "Rolling"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "internal_training_${terraform.workspace}${var.module_suffix}"
  }
}