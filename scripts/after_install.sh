#!/bin/bash

# Function to check if a package is installed
check_installation() {
    if command -v "$1" &> /dev/null; then
        echo "$1 is installed."
    else
        echo "$1 is NOT installed."
    fi
}

# Function to check if a specific file exists
check_file_exists() {
    if [ -f "$1" ]; then
        echo "File $1 exists."
    else
        echo "File $1 does not exist."
    fi
}

# Verify Docker installation
echo "Verifying Docker installation..."
check_installation docker

# Verify jq installation
echo "Verifying jq installation..."
check_installation jq

# Verify curl installation
echo "Verifying curl installation..."
check_installation curl

# Verify Docker Compose installation
echo "Verifying Docker Compose installation..."
check_installation docker-compose

# Check if docker-compose.env.yml exists
echo "Checking if docker-compose.env.yml exists in /home/kube_user/..."
check_file_exists "/home/kube_user/docker-compose.env.yml"

# Summary of verification
echo -e "\nVerification complete."
