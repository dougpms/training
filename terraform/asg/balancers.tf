resource "aws_lb" "lb_ec2" {
  name               = "lb-${terraform.workspace}"
  internal           = false  # Set to true if you want an internal ELB
  load_balancer_type = "application"  # Use "network" for a network load balancer

  security_groups = [module.vpc.sg_name]
  subnets         = [module.vpc.subnet_id_public]

  enable_http2    = true

  enable_deletion_protection = false

  tags = local.tags
}

resource "aws_lb_target_group" "lb_ec2_tg" {
  name        = "lb-ec2-exercise-${terraform.workspace}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
}

#resource "aws_lb_target_group_attachment" "lb_ec2_tg_att" {
#  count = length(module.ec2.ec2_name)
#  target_group_arn = aws_lb_target_group.lb_ec2_tg.arn
#  target_id        = module.ec2.ec2_name[count.index]
#  port             = 80
#}




