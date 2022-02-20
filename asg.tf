# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "tw-allow-lb-ec2"
  description = "Allow LB to EC2"
  vpc_id      = module.vpc.aws_vpc_id

  tags = merge({
    Name = "tw-allow-lb-ec2"
  }, var.custom_tags)
}

resource "aws_security_group_rule" "ec2_sg_frontend" {
  security_group_id        = aws_security_group.ec2_sg.id
  type                     = "ingress"
  from_port                = var.container_details.frontend_port
  to_port                  = var.container_details.frontend_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "ec2_sg_static" {
  security_group_id        = aws_security_group.ec2_sg.id
  type                     = "ingress"
  from_port                = var.container_details.static_port
  to_port                  = var.container_details.static_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "ec2_sg_quotes" {
  security_group_id        = aws_security_group.ec2_sg.id
  type                     = "ingress"
  from_port                = var.container_details.quotes_port
  to_port                  = var.container_details.quotes_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "ec2_sg_newsfeed" {
  security_group_id        = aws_security_group.ec2_sg.id
  type                     = "ingress"
  from_port                = var.container_details.newsfeed_port
  to_port                  = var.container_details.newsfeed_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "ec2_sg_outbound" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Launch Configuration
resource "aws_launch_configuration" "lc" {
  name_prefix   = "tw-lc"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.large"
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile = aws_iam_instance_profile.ecs_service_role.name
  # key_name                    = var.key_name
  security_groups = [aws_security_group.ec2_sg.id]
  user_data       = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF

}

# Auto scaling group
resource "aws_autoscaling_group" "asg" {
  name_prefix               = "tw-asg"
  launch_configuration      = aws_launch_configuration.lc.name
  min_size                  = var.instance.asg_min_size
  max_size                  = var.instance.asg_max_size
  desired_capacity          = var.instance.asg_desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier = [
    module.vpc.private_subnet1_id,
    module.vpc.private_subnet2_id
  ]

  #   target_group_arns     = [aws_lb_target_group.lb_target_group.arn]
  protect_from_scale_in = true
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "tw-asg"
    propagate_at_launch = true
  }
}
