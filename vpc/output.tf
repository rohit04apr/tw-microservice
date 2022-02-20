// VPC ID
output "aws_vpc_id" {
  value = aws_vpc.development.id
}

// Private Subnet ID
output "private_subnet1_id" {
  value = aws_subnet.private_1.id
}

// Private Subnet ID
output "private_subnet2_id" {
  value = aws_subnet.private_2.id
}

// Public Subnet ID
output "public_subnet1_id" {
  value = aws_subnet.public_1.id
}

// Public Subnet ID
output "public_subnet2_id" {
  value = aws_subnet.public_2.id
}