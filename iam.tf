# Role for EC2
resource "aws_iam_role" "ecs-instance-role" {
  name = "tw-ecs-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_service_role" {
  role = aws_iam_role.ecs-instance-role.name
}


# Role for ECS cluster
resource "aws_iam_role" "ecs-tasks-role" {
  name = "tw-ecs-tasks-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-tasks-role-attachment" {
  role       = aws_iam_role.ecs-tasks-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

