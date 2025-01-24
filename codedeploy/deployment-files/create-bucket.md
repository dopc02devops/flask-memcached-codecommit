###################
Create bucket
###################
- create s3 bucket and upload the ZIP file
    aws s3api create-bucket --bucket flask-memcached-app-bucket \
    --region eu-west-2 \
    --create-bucket-configuration LocationConstraint=eu-west-2
- list buckets
    aws s3api list-buckets
    aws s3api get-bucket-location --bucket flask-memcached-app-bucket

- copy file to bucket
    aws s3 cp flask-memcached-App.zip s3://flask-memcached-app-bucket/flask