#!/bin/bash

# Define variables
USER_NAME="kube_user"
PUB_KEY="myKey"

echo "Starting script execution..."

# 1. Create a user if it doesn't already exist
if id "$USER_NAME" &>/dev/null; then
    echo "User $USER_NAME already exists."
else
    echo "Creating user $USER_NAME..."
    sudo useradd -m -s /bin/bash "$USER_NAME"
    echo "User $USER_NAME created."
fi

# 2. Add the public SSH key to the user's authorized keys
USER_HOME=$(eval echo "~$USER_NAME")
SSH_DIR="$USER_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

echo "Setting up SSH for $USER_NAME..."
sudo mkdir -p "$SSH_DIR"
sudo chmod 700 "$SSH_DIR"
echo "$PUB_KEY" | sudo tee -a "$AUTHORIZED_KEYS" > /dev/null
sudo chmod 600 "$AUTHORIZED_KEYS"
sudo chown -R "$USER_NAME:$USER_NAME" "$SSH_DIR"
echo "Public key added to $AUTHORIZED_KEYS."

# 3. Add the user to the 'sudo' group (allowing sudo privileges)
echo "Adding $USER_NAME to the sudo group..."
sudo usermod -aG sudo "$USER_NAME"
echo "$USER_NAME added to sudo group."

# 4. Create 'docker' group if it doesn't exist and add user to it
if ! getent group docker >/dev/null; then
    echo "Creating 'docker' group..."
    sudo groupadd docker
    echo "'docker' group created."
else
    echo "'docker' group already exists."
fi

echo "Adding $USER_NAME to the docker group..."
sudo usermod -aG docker "$USER_NAME"
echo "$USER_NAME added to the docker group."

# 5. Install AWS CodeBuild Agent
echo "Installing AWS CodeBuild agent..."

# Update the system and install required packages
sudo yum update -y
sudo yum install -y aws-cli jq

# Download the CodeBuild agent
CODEBUILD_AGENT_URL="https://d3kbcqa49mib13.cloudfront.net/latest/codebuild-agent.tar.gz"
sudo mkdir -p /usr/local/codebuild-agent
cd /usr/local/codebuild-agent
sudo curl -O $CODEBUILD_AGENT_URL
sudo tar -xzf codebuild-agent.tar.gz
sudo rm -f codebuild-agent.tar.gz

# Install the CodeBuild agent
sudo yum install -y python3
sudo python3 -m pip install boto3
echo "Starting CodeBuild agent..."
sudo nohup ./agent &

echo "CodeBuild agent installed and started successfully."

echo "Script execution completed."
