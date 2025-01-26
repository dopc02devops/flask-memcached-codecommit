A deployment is the process of deploying a revision (application code or configuration files) to the specified deployment group. The command triggers the deployment of an application revision (like an S3 file, GitHub repo, or ZIP file) to the compute resources (like EC2 instances, Lambda functions, or ECS services) associated with a specified deployment group

###################
Create deployment
###################
 - Create a Deployment
    aws deploy create-deployment \
        --application-name flask-memcached-app \
        --deployment-group-name flask-memcached-Deploy-Group \
        --revision '{
            "revisionType": "S3",
            "s3Location": {
                "bucket": "flask-memcached-app-bucket",
                "key": "flask-memcached-app.zip",
                "bundleType": "zip"
            }
        }' \
        --description "S3 Deployment"


    aws deploy create-deployment \
        --application-name flask-memcached-app \
        --deployment-group-name flask-memcached-Deploy-Group \
        --revision '{
            "revisionType": "GitHub",
            "gitHubLocation": {
                "repository": "dopc02devops/flask-memcached-codecommit",
                "commitId": "2cdcfc7"
            }
        }' \
        --description "GitHub Deployment"


- get deployment
    aws deploy list-deployments \
        --application-name flask-memcached-app \
        --deployment-group-name flask-memcached-Deploy-Group

