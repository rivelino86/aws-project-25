# ec2 instance codes

resource "aws_instance" "web-server" {
  ami                    = "ami-00ca32bbc84273381"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.pub1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name  = aws_key_pair.my-key.key_name
  user_data = file("setup.sh")

  tags = {
    Name = "Terraform-server"
    env  = "Dev"
  }
}

// ebs volume

resource "aws_ebs_volume" "my-volume" {
  size = 20
  availability_zone = aws_instance.web-server.availability_zone
  tags = {
    Name = "Extra-vol"
  }
}
resource "aws_volume_attachment" "att-vol" {
  instance_id = aws_instance.web-server.id
  volume_id = aws_ebs_volume.my-volume.id
  device_name = "/dev/sdb"

}
