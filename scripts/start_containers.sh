#!/bin/bash

# Set the version directly
VERSION="latest"

# Log the version for debugging
echo "VERSION set: $VERSION"

cd /home/kube_user/

# Path to the docker-compose.env.yml file
COMPOSE_FILE_PATH="docker-compose.env.yml"

# Check if the compose file exists
if [[ ! -f "$COMPOSE_FILE_PATH" ]]; then
    echo "Error: $COMPOSE_FILE_PATH does not exist."
    exit 1
fi

# Debug: Show the file before replacement
echo "Before replacement:"
cat "$COMPOSE_FILE_PATH"

# Replace the version in the docker-compose.env.yml file
sed -i "s|\${VERSION}|$VERSION|g" "$COMPOSE_FILE_PATH"

# Debug: Show the file after replacement
echo "After replacement:"
cat "$COMPOSE_FILE_PATH"

# Check if volumes exist, create them if not
sudo docker volume inspect flask-app-data &>/dev/null || { echo "Creating flask-app-data volume..."; sudo docker volume create flask-app-data; }
sudo docker volume inspect memcached-data &>/dev/null || { echo "Creating memcached-data volume..."; sudo docker volume create memcached-data; }

# Bring up the Docker containers with docker-compose
sudo docker-compose -f "$COMPOSE_FILE_PATH" up -d

# Check if containers are running
echo "Checking container status..."
RUNNING_CONTAINERS=$(sudo docker ps --filter "status=running" --format "{{.Names}}")

if [[ -z "$RUNNING_CONTAINERS" ]]; then
    echo "No containers are running. Please check for errors in the docker-compose logs."
    exit 1
else
    echo "The following containers are up and running:"
    echo "$RUNNING_CONTAINERS"
fi

echo "Containers started successfully with Flask app version $VERSION!"
