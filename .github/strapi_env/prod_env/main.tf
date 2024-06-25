# Define the AWS key pair resource
resource "aws_key_pair" "strapi-private-key" {
  key_name   = "strapi-private-key"
  public_key = var.ssh_public_key  # Update with your public key path
}

# Define the AWS instance resource
resource "aws_instance" "strapi" {
  ami           = "ami-0705384c0b33c194c"   # Canonical, Ubuntu 22.04 LTS amd64
  instance_type = "t3.small"
  key_name      = aws_key_pair.strapi-private-key.key_name
  subnet_id     = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.strapiSG.id]  # Use vpc_security_group_ids instead of security_group_ids

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y git curl
    sudo curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
    sudo npm install -g pm2
    sudo apt install -y yarn
    mkdir -p /srv/strapi
    cd /srv/strapi
    sudo git clone https://github.com/VyankateshwarTaikar/strapi.git .
    npm install 
    sleep 10
    pm2 start npm --name "strapi" -- start
  EOF

  tags = {
    Name = "vyankatesh-strapi-server"
  }
}
