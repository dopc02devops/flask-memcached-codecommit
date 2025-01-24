
An Auto Scaling Group (ASG) automatically adjusts the number of compute resources to meet the demand. It helps ensure that your application has the right amount of capacity at any given time, scaling up or down based on predefined conditions

- Scaling Up: If there’s an increase in traffic or demand, the Auto Scaling Group can   
   automatically launch more instances to handle the load
- Scaling Down: If demand decreases, the Auto Scaling Group will automatically terminate 
  unnecessary instances to save resources and reduce costs
- Health Checks: The system continuously monitors the health of instances, and if an 
  instance becomes unhealthy it is replaced with a new one
- Configuration: You can define the minimum and maximum number of instances the ASG can 
  scale between, as well as conditions for scaling (like CPU utilisation thresholds, 
  network traffic, or time of day)

#############################
Create the Auto Scaling Group
#############################
aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name flask-memcached-auto-scaling-group \
    --launch-template "LaunchTemplateName=flask-memcached-template,Version=2" \
    --min-size 1 \
    --max-size 4 \
    --desired-capacity 2 \
    --vpc-zone-identifier "subnet-05888a03e0511ede0,subnet-0f63b4f01d0bec499" \
    --health-check-type EC2 \
    --health-check-grace-period 300 \
    --tags Key=Name,Value=Flask-Memcached-Instance,PropagateAtLaunch=true

- get scalling group
    aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names flask-memcached-auto-scaling-group

- update scalling group
    aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name flask-memcached-auto-scaling-group \
    --desired-capacity 0 \
    --min-size 0


- delete scalling group
    aws autoscaling delete-auto-scaling-group \
    --auto-scaling-group-name flask-memcached-auto-scaling-group