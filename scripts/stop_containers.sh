#!/bin/bash

# Stop the Docker containers
docker-compose -f docker-compose.env.yml down

docker volume rm flask-app-data
docker volume rm memcached-data

echo "Containers stopped successfully!"
