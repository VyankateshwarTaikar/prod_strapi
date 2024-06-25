# Create a new VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "For strapi deployment"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "default" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"  # Replace with desired CIDR block
  availability_zone       = "eu-north-1a"  # Replace with desired AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "Default Subnet"
  }
}

# Create a security group for the VPC
resource "aws_security_group" "strapiSG" {
  name   = "strapi-sg"
  vpc_id = aws_vpc.vpc.id 

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Strapi"
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Strapi Security Group"
  }
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Strapi Internet Gateway"
  }
}

# Create a route table for the VPC
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Strapi Route Table"
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "route1" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.default.id
}
