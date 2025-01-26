A deployment is the process of deploying a revision (application code or configuration files) to the specified deployment group. The command triggers the deployment of an application revision (like an S3 file, GitHub repo, or ZIP file) to the compute resources (like EC2 instances, Lambda functions, or ECS services) associated with a specified deployment group

###################
Create deployment
###################
 - Create a Deployment
    aws deploy create-deployment \
        --application-name flask-memcached-app \
        --deployment-group-name flask-memcached-deployment-group \
        --revision '{
            "revisionType": "S3",
            "s3Location": {
                "bucket": "flask-memcached-app-bucket/flask",
                "key": "flask-memcached-App.zip",
                "bundleType": "zip"
            }
        }' \
        --description "S3 Deployment"


    aws deploy create-deployment \
        --application-name flask-memcached-app \
        --deployment-group-name flask-memcached-deployment-group \
        --revision '{
            "revisionType": "GitHub",
            "gitHubLocation": {
                "repository": "dopc02devops/flask-memcached-codecommit",
                "commitId": "abcdef1234567890"
            }
        }' \
        --description "GitHub Deployment"
