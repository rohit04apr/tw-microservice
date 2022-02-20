resource "aws_ecs_cluster" "web-cluster" {
  name               = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.ecs.name]
  tags = merge({
    Name = var.cluster_name
  }, var.custom_tags)
}

resource "aws_ecs_capacity_provider" "ecs" {
  name = "capacity-provider-ecs"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

# update file containers.json, so it's pulling image from docker hub
resource "aws_ecs_task_definition" "task-definition-ecs" {
  family                   = "tw-task"
  container_definitions    = data.template_file.task_definition_container.rendered
  network_mode             = "bridge"
  task_role_arn            = aws_iam_role.ecs-tasks-role.arn
  cpu                      = "1024"
  memory                   = "2048"
  requires_compatibilities = ["EC2"]
  tags = merge({
    Name = "tw-task"
  }, var.custom_tags)
}


resource "aws_ecs_service" "service" {
  name            = "tw-service1"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-ecs.arn
  desired_count   = var.instance.ecs_task_count
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group_frontend.arn
    container_name   = "tw-frontend"
    container_port   = var.container_details.frontend_port
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group_static.arn
    container_name   = "tw-static"
    container_port   = var.container_details.static_port
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group_quotes.arn
    container_name   = "tw-quotes"
    container_port   = var.container_details.quotes_port
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group_newsfeed.arn
    container_name   = "tw-newsfeed"
    container_port   = var.container_details.newsfeed_port
  }

  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on = [aws_lb_listener.web_listener_frontend,
    aws_lb_listener.web_listener_static,
    aws_lb_listener.web_listener_quotes,
  aws_lb_listener.web_listener_newsfeed]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/tw-container"
  tags = merge({
    Name = "tw-container"
  }, var.custom_tags)
}
