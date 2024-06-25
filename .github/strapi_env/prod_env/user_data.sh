#!/bin/bash

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y git nodejs npm docker.io

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add the ubuntu user to the docker group
sudo usermod -aG docker ubuntu

# Navigate to the /srv directory
cd /srv

# Configure Git
git config --global user.name "vyankateshtaikar"
git config --global user.email "vyankateshtaikar1312@gmail.com"

# Clone the Strapi project repository and change to the project directory
git clone https://github.com/PearlThoughts-DevOps-Internship/strapi.git
cd strapi

# Check out the correct branch
git checkout mainprod_strap

# Set permissions for the project directory
sudo chown -R ubuntu:ubuntu /srv/strapi
sudo chmod -R 755 /srv/strapi

# Create .env file with the required environment variables
cat <<EOT > .env
HOST=0.0.0.0
PORT=1337
APP_KEYS="toBeModified1,toBeModified2"
API_TOKEN_SALT=tobemodified
ADMIN_JWT_SECRET=tobemodified
TRANSFER_TOKEN_SALT=tobemodified
JWT_SECRET=tobemodified
EOT

# Build the Docker image for the Strapi project
sudo docker build -t strapi-app .

# Run the Strapi container
sudo docker run -d -p 1337:1337 --name strapi-app --env-file .env strapi-app

# Ensure the Strapi container starts on boot
sudo tee /etc/systemd/system/strapi-app.service > /dev/null <<EOF
[Unit]
Description=Strapi Container
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a strapi-app
ExecStop=/usr/bin/docker stop -t 2 strapi-app

[Install]
WantedBy=default.target
EOF

sudo systemctl enable strapi-app.service

echo "Setup complete. Strapi should now be running and accessible at http://<your-ec2-instance-public-ip>:1337"
