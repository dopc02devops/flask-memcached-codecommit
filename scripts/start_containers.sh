#!/bin/bash

# Ensure a version is passed as a parameter
if [ -z "$1" ]; then
  echo "Error: Version parameter is required."
  echo "Usage: script/start_containers.sh <version>"
  exit 1
fi

VERSION=$1

# Replace the version in the docker-compose.env.yml file
sed -i "s/\${VERSION}/$VERSION/g" docker-compose.env.yml

# Check if volumes exist, create them if not
docker volume inspect flask-app-data &>/dev/null || docker volume create flask-app-data
docker volume inspect memcached-data &>/dev/null || docker volume create memcached-data

# Bring up the Docker containers with docker-compose
docker-compose -f docker-compose.env.yml up -d

echo "Containers started successfully with Flask app version $VERSION!"
