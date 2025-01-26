#########################
create codebuild projects 
#########################
aws codebuild create-project \
    --name flask-memcached-build-Project \
    --source "{\"type\": \"GITHUB\", \"location\": \"https://github.com/dopc02devops/flask-memcached-codecommit\", \"buildspec\": \"buildspecs/buildspec-build.yaml\"}" \
    --artifacts type=S3,location=terraform-qe33fdtgs86ltdhsiuyyu \
    --environment type=LINUX_CONTAINER,image=aws/codebuild/standard:7.0,computeType=BUILD_GENERAL1_SMALL \
    --service-role arn:aws:iam::908027384199:role/codebuild-role \
    --region eu-west-2

aws codebuild create-project \
    --name flask-memcached-test-Project \
    --source "{\"type\": \"GITHUB\", \"location\": \"https://github.com/dopc02devops/flask-memcached-codecommit\", \"buildspec\": \"buildspecs/buildspec-test.yaml\"}" \
    --artifacts type=S3,location=terraform-qe33fdtgs86ltdhsiuyyu \
    --environment type=LINUX_CONTAINER,image=aws/codebuild/standard:7.0,computeType=BUILD_GENERAL1_SMALL \
    --service-role arn:aws:iam::908027384199:role/codebuild-role \
    --region eu-west-2

aws codebuild create-project \
    --name flask-memcached-Project \
    --source "{\"type\": \"GITHUB\", \"location\": \"https://github.com/dopc02devops/flask-memcached-codecommit\"}" \
    --artifacts type=S3,location=terraform-qe33fdtgs86ltdhsiuyyu \
    --environment type=LINUX_CONTAINER,image=aws/codebuild/standard:7.0,computeType=BUILD_GENERAL1_SMALL \
    --service-role arn:aws:iam::908027384199:role/codebuild-role \
    --region eu-west-2
 