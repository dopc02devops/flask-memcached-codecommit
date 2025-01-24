
###################
Create deployment
###################
 - Create a Deployment
    aws deploy create-deployment \
        --application-name flask-memcached-app \
        --deployment-group-name flask-memcached-deployment-group \
        --s3-location bucket=flask-memcached-app-bucket/flask,key=my-flask-memcached-   
          App.zip,bundleType=zip
