// Use the endpoint to connect to the application
output "alb_endpoint" {
  value = aws_lb.tw_lb.dns_name
}