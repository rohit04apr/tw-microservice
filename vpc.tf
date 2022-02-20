# Module to create VPC
module "vpc" {
  source = "./vpc"

  availability_zone = data.aws_availability_zones.available.names
  vpc_cidr          = var.vpc.vpc_cidr
  subnet_private_1  = var.vpc.subnet_private_1
  subnet_private_2  = var.vpc.subnet_private_2
  subnet_public_1   = var.vpc.subnet_public_1
  subnet_public_2   = var.vpc.subnet_public_2

  custom_tags = var.custom_tags

  providers = {
    aws = aws
  }
}