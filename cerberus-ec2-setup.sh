#!/bin/bash

# Script to set up an EC2 instance for the Cerberus application

echo "Updating system and installing Docker and Git..."
sudo apt update
sudo apt install -y docker.io git

echo "Adding the user to the Docker group..."
sudo usermod -aG docker $USER

echo "Cloning the Cerberus repository..."
if [ ! -d "cerberus-devops" ]; then
  git clone https://github.com/jkot16/cerberus-devops.git
fi

cd cerberus-devops || { echo "Cerberus directory not found"; exit 1; }

chmod +x /home/ubuntu/cerberus-devops/cerberus-healthcheck.sh

echo "Building the Docker image..."
docker build -t cerberus-app .

echo "🛑 Stopping any existing Cerberus container..."
docker stop cerberus 2>/dev/null || true
docker rm cerberus 2>/dev/null || true

echo "Ensuring log file exists..."
LOG_PATH="/home/ubuntu/cerberus-devops/cerberus.log"
if [ ! -f "$LOG_PATH" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cerberus log initialized." > "$LOG_PATH"
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cerberus log already exists." >> "$LOG_PATH"
fi


echo "Starting the Cerberus container..."
docker run -d -p 80:5000 \
  -v /home/ubuntu/cerberus-devops/cerberus.log:/app/cerberus.log \
  --name cerberus \
  --restart always \
  cerberus-app

echo "Please enter your Discord webhook URL:"
read -p "Webhook URL: " WEBHOOK_URL

echo "Setting up Cerberus watchdog cronjob..."
if ! crontab -l 2>/dev/null | grep -q "cerberus-healthcheck.sh"; then
  (crontab -l 2>/dev/null; echo "* * * * * CERBERUS_WEBHOOK_URL=\"$WEBHOOK_URL\" /home/ubuntu/cerberus-devops/cerberus-healthcheck.sh") | crontab -
  echo "✅ Cronjob added!"
else
  echo "ℹ️ Cronjob already exists. Skipping..."
fi

echo "✅ Setup complete! Cerberus is running on port 80."
