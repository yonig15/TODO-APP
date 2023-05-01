#!/bin/bash

# Connect to the EC2 instance using SSH
ssh -i /path/to/aws_finel.pem ec2-16-16-144-83.eu-north-1.compute.amazonaws.com

# Install Docker and Docker Compose on the EC2 instance if they are not already installed
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Stop and remove any existing containers that are running on the EC2 instance
sudo docker-compose down

# Pull the latest Docker image from Docker Hub
sudo docker-compose pull

# Start the new containers based on the Docker image
sudo docker-compose up -d

# Check the health of the application by running a curl command to the health endpoint
if curl -sSf http://localhost:3000/health > /dev/null; then
    echo "Application is healthy."
    exit 0
else
    echo "Application is not healthy."
    # Send a notification via Slack or email
    # ...
    exit 1
fi
