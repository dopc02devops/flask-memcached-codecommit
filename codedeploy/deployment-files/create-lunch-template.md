

######################
create lunch template 
######################
- get subnets and edit launch-template-data.json file
    command: aws ec2 describe-subnets --region eu-west-2
- create ec2 role in console and attach below policies
    role: ec2-role
    policies
        CloudWatchAgentServerPolicy
        AmazonSSMManagedInstanceCore
        AWSCodeDeployRole
        AmazonS3FullAccess
        CloudWatchFullAccess
        AWSCodePipeline_FullAccess
        AmazonS3FullAccess

- create instance profile 
    command: aws iam create-instance-profile --instance-profile-name flask-memcached-instance-profile

- add role to instance-profile and edit launch-template-data.json file
    command: aws iam add-role-to-instance-profile --instance-profile-name flask-memcached-instance-profile --role-name ec2-role

- cd codedeploy  
- run below command to encoded user-data.sh and add encoded string to  launch-template-data.json Userdata field
    echo "$(base64 -i user-script.sh | sed 's/^/    "UserData": "/;s/$/",/')" | sed -i "" 
    "/\"UserData\"/{
        r /dev/stdin
        d
    }" launch-template-data.json

- run command to create new template
    aws ec2 create-launch-template \
    --launch-template-name flask-memcached-template \
    --version-description "v1" \
    --launch-template-data file://launch-template-data.json

- to version existing template 
    aws ec2 create-launch-template-version \
    --launch-template-name flask-memcached-template \
    --version-description "v2" \
    --launch-template-data file://launch-template-data.json

- get sport instance rate
    aws ec2 describe-spot-price-history --instance-types t2.micro t2.small t2.medium --product-description "Linux/UNIX" --start-time "2025-01-23T00:00:00Z"

