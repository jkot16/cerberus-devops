#!/bin/bash

# Script to set up an EC2 instance for the Cerberus application

echo "Updating system and installing Docker and Git..."
sudo apt update
sudo apt install -y docker.io git

echo "Adding the user to the Docker group..."
sudo usermod -aG docker $USER
newgrp docker

echo "Cloning the Cerberus repository..."
if [ ! -d "cerberus-devops" ]; then
  git clone https://github.com/jkot16/cerberus-devops.git
fi

cd cerberus-devops || { echo "Cerberus directory not found"; exit 1; }

echo "Building the Docker image..."
docker build -t cerberus-app .

echo "🛑 Stopping any existing Cerberus container..."
docker stop cerberus 2>/dev/null || true
docker rm cerberus 2>/dev/null || true

echo "Starting the Cerberus container..."
docker run -d -p 80:5000 \
  -v /home/ubuntu/cerberus-devops/cerberus.log:/app/cerberus.log \
  --name cerberus \
  --restart always \
  cerberus-app

echo "Cerberus is now running on port 80!"