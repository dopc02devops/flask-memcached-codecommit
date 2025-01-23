#!/bin/bash

USER_NAME="kube_user"
PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCVG5b1Eb1+VRWgWm7rVYk6SwqTClBkqYGN728UkOnuIsk698KIQvFDiGSFkMGGvkNB8loK9cnW4o9jLJIWAuv8HviaOthb0YtNY32plzAQigKT322JjC2iCuomMCfZqQJK/BO5Dzh2wZN3/IzhytCPkScPSKQ27Ra/bRhpxbUxKRazOAB02wT2Zed5XUsP13L+paDQG5f/iIePqLUN5kVna8QXHHFKT98ZpmRII7M6PmxuCpdSuCaq6FFiK8kJ/RoYjZ8K3BuxySni1iuvqM8ESb8eE23vtxOHqRZqUw7lGwvKQeZwWToiPZcgBTpdDf/19fARjv9CWywaVyv0kKRSGBBOpotHxazOY+u8t94gLVwD0fRtMqrSvtisSbJTEq36l9udREPZQ2DcKwrXtyozIbTus5fVs3xeTtgkwolU+qH+xOUCv4uaYOy9U0dY6qe5PhQURckGjUqu0KXJIysSK68YQhfAAVDXnB6k6Lt6T3CzFEaNFtMbTrrlShh80cZX9uVkPLJ7KSqFoIT8mliLwCiGKnYi/v619CRl45vKXJPvMd/daWmVr+7SQndKsdUxBM7eyVYeJpujpZlEdbzgqVDwkVfa3jdzrKDMnMKAWQe9iuUCWuPD8CybOaZIpj1ipSq2zjDsMK3yMn5fCNJUg4PHHwbmkuFlm41YITKTMw== terraform
"

echo "Starting script execution..."

# Create user if not exists
if ! id "$USER_NAME" &>/dev/null; then
    echo "Creating user $USER_NAME..."
    sudo useradd -m -s /bin/bash "$USER_NAME"
fi

# Set up SSH
USER_HOME=$(eval echo "~$USER_NAME")
SSH_DIR="$USER_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

echo "Setting up SSH for $USER_NAME..."
sudo mkdir -p "$SSH_DIR" && sudo chmod 700 "$SSH_DIR"
echo "$PUB_KEY" | sudo tee -a "$AUTHORIZED_KEYS" > /dev/null
sudo chmod 600 "$AUTHORIZED_KEYS" && sudo chown -R "$USER_NAME:$USER_NAME" "$SSH_DIR"

# Add user to groups
echo "Adding $USER_NAME to groups..."
sudo usermod -aG sudo docker "$USER_NAME"
sudo getent group docker &>/dev/null || sudo groupadd docker

# Install AWS CodeBuild Agent
echo "Installing AWS CodeBuild agent..."
sudo yum update -y && sudo yum install -y aws-cli jq python3
sudo python3 -m pip install boto3

sudo mkdir -p /usr/local/codebuild-agent && cd /usr/local/codebuild-agent
sudo curl -O https://d3kbcqa49mib13.cloudfront.net/latest/codebuild-agent.tar.gz
sudo tar -xzf codebuild-agent.tar.gz && sudo rm -f codebuild-agent.tar.gz

# Create and enable systemd service for the agent
echo "Setting up CodeBuild agent service..."
sudo tee /etc/systemd/system/codebuild-agent.service > /dev/null <<EOF
[Unit]
Description=AWS CodeBuild Agent
After=network.target

[Service]
ExecStart=/usr/local/codebuild-agent/agent
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable codebuild-agent
sudo systemctl start codebuild-agent

echo "CodeBuild agent enabled and started successfully."
echo "Script execution completed."

# pbcopy < ~/.ssh/id_kube_user_key.pub