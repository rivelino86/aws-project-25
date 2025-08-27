resource "aws_s3_bucket" "my-bucket" {
  bucket = "w7-mybucket-file"

  tags = {
    Name = "Dev-s3"
  }
}