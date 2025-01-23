#!/bin/bash

USER_NAME="kube_user"
PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCVG5b1Eb1+VRWgWm7rVYk6SwqTClBkqYGN728UkOnuIsk698KIQvFDiGSFkMGGvkNB8loK9cnW4o9jLJIWAuv8HviaOthb0YtNY32plzAQigKT322JjC2iCuomMCfZqQJK/BO5Dzh2wZN3/IzhytCPkScPSKQ27Ra/bRhpxbUxKRazOAB02wT2Zed5XUsP13L+paDQG5f/iIePqLUN5kVna8QXHHFKT98ZpmRII7M6PmxuCpdSuCaq6FFiK8kJ/RoYjZ8K3BuxySni1iuvqM8ESb8eE23vtxOHqRZqUw7lGwvKQeZwWToiPZcgBTpdDf/19fARjv9CWywaVyv0kKRSGBBOpotHxazOY+u8t94gLVwD0fRtMqrSvtisSbJTEq36l9udREPZQ2DcKwrXtyozIbTus5fVs3xeTtgkwolU+qH+xOUCv4uaYOy9U0dY6qe5PhQURckGjUqu0KXJIysSK68YQhfAAVDXnB6k6Lt6T3CzFEaNFtMbTrrlShh80cZX9uVkPLJ7KSqFoIT8mliLwCiGKnYi/v619CRl45vKXJPvMd/daWmVr+7SQndKsdUxBM7eyVYeJpujpZlEdbzgqVDwkVfa3jdzrKDMnMKAWQe9iuUCWuPD8CybOaZIpj1ipSq2zjDsMK3yMn5fCNJUg4PHHwbmkuFlm41YITKTMw== terraform"
REGION="eu-west-2"
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

# Add user to sudo group
echo "Adding $USER_NAME to sudo group..."
sudo usermod -aG sudo "$USER_NAME"

# Add user to docker group
echo "Adding $USER_NAME to docker group..."
sudo usermod -aG docker "$USER_NAME"

# Ensure docker group exists
echo "Checking if docker group exists..."
sudo getent group docker &>/dev/null || sudo groupadd docker

# Configure passwordless sudo
echo "Configuring passwordless sudo for $USER_NAME..."
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER_NAME > /dev/null
sudo chmod 440 /etc/sudoers.d/$USER_NAME

# Confirm if groups were added successfully
echo "Verifying user groups..."
groups "$USER_NAME"

# Verify sudo access for the user
echo "Testing sudo access for $USER_NAME..."
sudo -v

# Install AWS CodeDeploy Agent
echo "Installing AWS CodeDeploy Agent..."
sudo yum update -y
sudo yum install -y ruby
sudo yum install -y wget
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent
sudo systemctl enable codedeploy-agent
echo "AWS CodeDeploy Agent installed and started."

# Install AWS CloudWatch Agent
echo "Installing AWS CloudWatch Agent..."
REGION="eu-west-2"
wget https://s3.${REGION}.amazonaws.com/amazoncloudwatch-agent-${REGION}/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm

# Create a local CloudWatch Agent configuration file
echo "Creating CloudWatch Agent configuration file..."
cat <<EOF | sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "agent": {
      "metrics_collection_interval": 60,
      "run_as_user": "root"
  },
  "metrics": {
      "append_dimensions": {
          "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
          "ImageId": "${aws:ImageId}",
          "InstanceId": "${aws:InstanceId}",
          "InstanceType": "${aws:InstanceType}"
      },
      "metrics_collected": {
          "disk": {
              "measurement": [
                  "used_percent"
              ],
              "metrics_collection_interval": 60,
              "resources": [
                  "*"
              ]
          },
          "mem": {
              "measurement": [
                  "mem_used_percent"
              ],
              "metrics_collection_interval": 60
          }
      }
  },
  "logs": {
      "logs_collected": {
          "files": {
              "collect_list": [
                  {
                      "file_path": "/var/log/cloud-init-output.log", 
                      "log_group_name": "flask-memcached-group",
                      "log_stream_name": "flask-memcached-stream", 
                      "timestamp_format": "%b %d %H:%M:%S"
                  }
              ]
          }
      }
  }
}

EOF

# Start the CloudWatch Agent with the local configuration file
echo "Starting CloudWatch Agent..."
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

# Enable the CloudWatch Agent to start on boot
echo "Enabling CloudWatch Agent to start on boot..."
sudo systemctl enable amazon-cloudwatch-agent

echo "AWS CloudWatch Agent installed, configured, and started.

echo "Script execution completed successfully."

# pbcopy < ~/.ssh/id_kube_user_key.pub
# sudo systemctl status codedeploy-agent
# sudo systemctl status amazon-cloudwatch-agent
# sudo journalctl -p err