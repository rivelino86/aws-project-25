# ---------------- VPC ----------------
resource "aws_vpc" "my-vpc" {
  cidr_block           = "172.120.0.0/16" # class B 65k ips
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name       = "utc-app1"
    env        = "Dev"
    app-name   = "utc"
    Team       = "wdp"
    created_by = "Rivelino"
  }
}

# ---------------- Subnets ----------------
resource "aws_subnet" "pub1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "172.120.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "utc-Pub-sub1"
  }
}

resource "aws_subnet" "pub2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "172.120.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "utc-Pub-sub2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "172.120.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "utc-Priv-sub1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "172.120.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "utc-Priv-sub2"
  }
}

# ---------------- Internet Gateway ----------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "utc-igw"
  }
}

# ---------------- NAT Gateway ----------------
resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "my-nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub1.id

  tags = {
    Name = "Utc-Nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route Tables ----------------
# Private route table (uses NAT)
resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nat.id
  }

  tags = {
    Name = "rt-private"
  }
}

# Public route table (uses Internet Gateway)
resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-public"
  }
}

# Public subnets → Public route table
resource "aws_route_table_association" "pub1_assoc" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.rtpublic.id
}

resource "aws_route_table_association" "pub2_assoc" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.rtpublic.id
}

# Private subnets → Private route table
resource "aws_route_table_association" "priv1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.rtprivate.id
}

resource "aws_route_table_association" "priv2_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.rtprivate.id
}


