variable "aws" {
  description = "(Required) Details about this AWS account"
  type        = map(string)

  default = {
    // IAM credentials for the AWS account
    access_key = ""
    secret_key = ""
    // the region for this environment
    region = "eu-central-1"
  }
}

variable "vpc" {
  description = "VPC configuration details"
  type        = map(string)
  default = {
    vpc_cidr         = "10.0.0.0/16"
    subnet_private_1 = "10.0.1.0/24"
    subnet_private_2 = "10.0.2.0/24"
    subnet_public_1  = "10.0.3.0/24"
    subnet_public_2  = "10.0.4.0/24"
  }
}

variable "container_details" {
  description = "Instance configuration details"
  type        = map(string)
  default = {
    frontend_image = "{dockerhub-username}/tw-frontend:v2"
    frontend_port  = "8001"
    static_image   = "{dockerhub-username}/tw-static:v2"
    static_port    = "8000"
    quotes_image   = "{dockerhub-username}/tw-quotes:v2"
    quotes_port    = "8002"
    newsfeed_image = "{dockerhub-username}/tw-newsfeed:v2"
    newsfeed_port  = "8003"

  }
}

variable "custom_tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys."
  type        = map(string)
  default = {
    CreatedBy = "terraform"
  }
}

variable "cluster_name" {
  type        = string
  description = "The name of AWS ECS cluster"
  default     = "tw-cluster"
}

variable "instance" {
  description = "Instance configuration details"
  type        = map(string)
  default = {
    asg_min_size         = 2
    asg_max_size         = 2
    asg_desired_capacity = 2
    ecs_task_count       = 2

  }
}

