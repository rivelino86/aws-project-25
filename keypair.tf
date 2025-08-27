# Generate a new RSA key pair locally

resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my-key" {
  key_name   = "w7-key"
  public_key = tls_private_key.keypair.public_key_openssh
}

resource "local_file" "private-key" {
  filename        = "w7-key.pem"
  file_permission = 0400
  content         = tls_private_key.keypair.private_key_openssh
}