# // Check for the Availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

// Grab the latest amazon-linux AMI from the API. We will use this
// when creating a new EC2 Instance.
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

data "template_file" "task_definition_container" {
  template = file("container-definitions/containers.json")
  vars = {
    frontend_image = var.container_details.frontend_image
    frontend_port  = var.container_details.frontend_port
    static_image   = var.container_details.static_image
    static_port    = var.container_details.static_port
    quotes_image   = var.container_details.quotes_image
    quotes_port    = var.container_details.quotes_port
    newsfeed_image = var.container_details.newsfeed_image
    newsfeed_port  = var.container_details.newsfeed_port
  }
}