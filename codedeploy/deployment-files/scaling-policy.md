Scaling Policies are rules or configurations used to define how an Auto Scaling Group (ASG) should scale its resources based on specific conditions, such as CPU utilisation, memory usage, or network traffic

- Target Tracking Scaling: The target tracking policy allows you to set a specific target 
  for a metric. The Auto Scaling Group then automatically adjusts the number of instances 
   to keep that metric near the target value

- Step Scaling Policy: This policy allows more granular control, where you can specify 
  different scaling actions based on the severity of the metric deviation. You define 
   step sizes, which determine how much to scale up or down based on thresholds

    If CPU utilisation exceeds 70%, add 2 instances
    If CPU utilisation exceeds 90%, add 4 instances
    If CPU utilisation drops below 40%, remove 1 instance
    This policy gives you flexibility in how much to scale based on the conditions

- Simple Scaling Policy: Specify a trigger (e.g., if CPU utilisation exceeds 80%) and 
  define a single action (e.g., add 1 instance).


##########################
Configure Scaling Policies
##########################
Tracking Scaling Policy
    aws autoscaling put-scaling-policy \
    --auto-scaling-group-name flask-memcached-auto-scaling-group \
    --policy-name scale-up \
    --policy-type TargetTrackingScaling \
    --target-tracking-configuration file://target-tracking-config.json

simple scalling policy 
    aws autoscaling put-scaling-policy \
    --auto-scaling-group-name flask-memcached-auto-scaling-group \
    --policy-name scale-up \
    --scaling-adjustment 1 \
    --adjustment-type ChangeInCapacity \
    --cooldown 300

    define cloudwatch alarm to handle scalling policy

    For adding instances (when CPU > 75%):
    aws cloudwatch put-metric-alarm \
    --alarm-name "HighCPUAlarm" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 300 \
    --threshold 75 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 1 \
    --alarm-actions arn:aws:autoscaling:<region>:<account-id>:scalingPolicy:<policy- 
      id>:autoScalingGroupName/<auto-scaling-group-name> \
    --dimensions "Name=AutoScalingGroupName,Value=<your-auto-scaling-group-name>"

Step Scaling Policy
    aws autoscaling put-scaling-policy \
    --auto-scaling-group-name flask-memcached-auto-scaling-group \
    --policy-name scale-up \
    --policy-type StepScaling \
    --cooldown 300 \
    --metric-aggregation-type Average \
    --estimated-instance-warmup 300 \
    --adjustment-type ChangeInCapacity \
    --step-adjustments "ScalingAdjustment=1,MetricIntervalLowerBound=0"

    define cloudwatch alarm to handle scalling policy
    
    aws cloudwatch put-metric-alarm \
    --alarm-name "HighCPUUtilisation" \
    --alarm-description "Alarm when CPU usage exceeds 70%" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 60 \
    --threshold 70 \
    --comparison-operator GreaterThanThreshold \
    --dimensions Name=AutoScalingGroupName,Value=my-auto-scaling-group \
    --evaluation-periods 2 \
    --alarm-actions arn:aws:automate:region:ec2:action/startInstances

delete 
    aws autoscaling delete-policy \
    --auto-scaling-group-name flask-memcached-auto-scaling-group \
    --policy-name scale-up