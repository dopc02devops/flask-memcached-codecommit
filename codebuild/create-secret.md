
#######################
create docker hub login
#######################
aws secretsmanager create-secret \
    --name "docker-credentials" \
    --description "Docker Hub credentials" \
    --secret-string '{"DOCKER_USERNAME":"dockerelvis","DOCKER_PASSWORD":"your_docker_password"}'

aws secretsmanager list-secrets --region eu-west-2 --output text

aws secretsmanager update-secret \
    --secret-id "docker-credentials" \
    --description "Docker Hub credentials" \
    --secret-string '{"DOCKER_USERNAME":"dockerelvis","DOCKER_PASSWORD":"your_updated_docker_password"}'

