output "public_ip" {
  value = aws_instance.web-server.public_ip
}

output "vpc-id" {
   value = aws_vpc.my-vpc.id
}