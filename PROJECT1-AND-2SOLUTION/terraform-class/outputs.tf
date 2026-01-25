output "default_vpc_id" {
  value = aws_default_vpc.default.id
}


output "web-url" {
  value = "http://${aws_instance.ec2_instance.public_ip}"
}