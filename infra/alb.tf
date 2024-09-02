########################################################################################################################
## Application Load Balancer in public subnets with HTTP default listener 
########################################################################################################################

resource "aws_alb" "alb" {
  name            = "${var.common_prefix}-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = data.aws_subnets.vpc_subnets.ids

  tags = local.common_tags
}

########################################################################################################################
## Default HTTP listener 
########################################################################################################################

resource "aws_alb_listener" "alb_default_listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }

  tags = local.common_tags


}


########################################################################################################################
## Target Group for our service
########################################################################################################################

resource "aws_alb_target_group" "service_target_group" {
  name                 = "${var.common_prefix}-target-group"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.resources_vpc.id
  deregistration_delay = 5

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    protocol            = "HTTP"
    timeout             = 30
  }

  tags = local.common_tags

  depends_on = [aws_alb.alb]
}