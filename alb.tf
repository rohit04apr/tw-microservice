resource "aws_lb" "tw_lb" {
  name               = "tw-ecs-lb"
  load_balancer_type = "application"
  internal           = false
  subnets = [
    module.vpc.public_subnet1_id,
    module.vpc.public_subnet2_id
  ]

  tags = merge({
    Name = "tw-ecs-lb"
  }, var.custom_tags)

  security_groups = [aws_security_group.lb.id]
}

resource "aws_security_group" "lb" {
  name   = "allow-all-lb"
  vpc_id = module.vpc.aws_vpc_id

  tags = merge({
    Name = "allow-all-lb"
  }, var.custom_tags)
}

resource "aws_security_group_rule" "lb_inbound" {
  security_group_id = aws_security_group.lb.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_outbound" {
  security_group_id = aws_security_group.lb.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb_target_group" "lb_target_group_frontend" {
  name        = "tw-frontend"
  port        = "80"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.aws_vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "web_listener_frontend" {
  load_balancer_arn = aws_lb.tw_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group_frontend.arn
  }
}

resource "aws_lb_target_group" "lb_target_group_static" {
  name        = "tw-static"
  port        = var.container_details.static_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.aws_vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "web_listener_static" {
  load_balancer_arn = aws_lb.tw_lb.arn
  port              = var.container_details.static_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group_static.arn
  }
}

resource "aws_lb_target_group" "lb_target_group_quotes" {
  name        = "tw-quotes"
  port        = var.container_details.static_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.aws_vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "web_listener_quotes" {
  load_balancer_arn = aws_lb.tw_lb.arn
  port              = var.container_details.quotes_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group_quotes.arn
  }
}

resource "aws_lb_target_group" "lb_target_group_newsfeed" {
  name        = "tw-newsfeed"
  port        = var.container_details.newsfeed_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.aws_vpc_id
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "web_listener_newsfeed" {
  load_balancer_arn = aws_lb.tw_lb.arn
  port              = var.container_details.newsfeed_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group_newsfeed.arn
  }
}