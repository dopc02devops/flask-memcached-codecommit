#######################################
Create bucket and copy files over to s3
#######################################
- create s3 bucket and upload the ZIP file
    aws s3api create-bucket --bucket flask-memcached-app-bucket \
    --region eu-west-2 \
    --create-bucket-configuration LocationConstraint=eu-west-2

zip -r flask-memcached-app.zip ./

- list buckets
    aws s3api list-buckets
    aws s3api get-bucket-location --bucket flask-memcached-app-bucket

- copy file to bucket
    aws s3 cp flask-memcached-app.zip s3://flask-memcached-app-bucket


- empty then delete bucket
    aws s3 rm s3://flask-memcached-app-bucket --recursive
    aws s3api delete-bucket --bucket flask-memcached-app-bucket
