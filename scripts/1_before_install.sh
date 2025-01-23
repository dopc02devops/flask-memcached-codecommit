#!/bin/bash
# Install Docker and Docker Compose if not installed
if ! command -v docker &> /dev/null
then
    sudo yum install -y docker
    sudo service docker start
fi

if ! command -v docker-compose &> /dev/null
then
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi
