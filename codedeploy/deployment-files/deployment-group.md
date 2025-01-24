
################
Deployment Group
################
- create codedeploy role 
- run below command
aws deploy create-deployment-group \
    --application-name flask-memcached-App \
    --deployment-group-name flask-memcached-Deploy-Group \
    --service-role-arn arn:aws:iam::908027384199:role/codedeploye-role \
    --deployment-config-name CodeDeployDefault.OneAtATime \
    --ec2-tag-filters Key=Name,Value=Flask-Memcached-Instance,Type=KEY_AND_VALUE \
    --auto-scaling-groups flask-memcached-auto-scaling-group \
    --load-balancer-info "targetGroupInfoList=[{name=flask-memcached-target-group}]" \
    --deployment-style "deploymentType=IN_PLACE,deploymentOption=WITHOUT_TRAFFIC_CONTROL" \
    --alarm-configuration "alarms=[{name=MyAlarm}],enabled=true,ignorePollAlarmFailure=false" \
    --trigger-configurations "triggerName=MyTrigger,triggerTargetArn=arn:aws:sns:eu-west-   
       8027384199:Mflask-memcached-SNSTopic,triggerEvents=[DeploymentSuccess,DeploymentFailure]" \
    --auto-rollback-configuration "enabled=true,events=. 
       [DEPLOYMENT_FAILURE,DEPLOYMENT_STOP_ON_ALARM,DEPLOYMENT_STOP_ON_REQUEST]" \
    --output json

- get deployment
    aws deploy get-deployment-group --application-name flask-memcached-App --deployment-group-name flask- 
    memcached-Deploy-Group
