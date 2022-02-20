variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "subnet_private_1" {
  type        = string
  description = "VPC Private Subnet CIDR"
}

variable "subnet_private_2" {
  type        = string
  description = "VPC Private Subnet CIDR"
}

variable "subnet_public_1" {
  type        = string
  description = "VPC Public Subnet CIDR"
}

variable "subnet_public_2" {
  type        = string
  description = "VPC Public Subnet CIDR"
}


variable "custom_tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys."
  type        = map(string)
  default = {

  }
}


variable "availability_zone" {
  description = "Availability zones"
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b",
  ]
}
