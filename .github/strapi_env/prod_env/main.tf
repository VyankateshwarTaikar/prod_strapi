# Define the AWS key pair resource
#resource "aws_key_pair" "strapi-private-key" {
#  key_name   = "strapi-private-key"
#  public_key = var.ssh_public_key  # Ensure var.ssh_public_key is defined and correct
#}

# Define the AWS instance resource
#resource "aws_instance" "strapi" {
#  ami                    = "ami-0705384c0b33c194c"  # Verify if this AMI is still available and suitable
  #instance_type          = "t3.small"
 # key_name               = aws_key_pair.strapi-private-key.key_name
  #subnet_id              = aws_subnet.default.id  # Ensure aws_subnet.default is correctly defined
 # vpc_security_group_ids = [aws_security_group.strapiSG.id]  # Ensure aws_security_group.strapiSG is correctly defined

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
