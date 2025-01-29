
#####################################
Create role to execute lambda
#####################################
aws iam create-role \
  --role-name LambdaExecutionRole \
  --assume-role-policy-document file://trust-policy.json

Attach the Policy to the Role
#####################################
aws iam put-role-policy \
  --role-name LambdaExecutionRole \
  --policy-name LambdaExecutionPolicy \
  --policy-document file://lambda-policy.json

Verify the Role and Policy
#####################################
aws iam get-role --role-name LambdaExecutionRole
aws iam get-role-policy --role-name LambdaExecutionRole --policy-name LambdaExecutionPolicy

#########################
create  EventBridge role
#########################
aws iam create-role \
  --role-name EventBridgeRole \
  --assume-role-policy-document file://trust-policy-event.json

aws iam attach-role-policy \
  --role-name EventBridgeRole \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess

aws iam attach-role-policy \
  --role-name EventBridgeRole \
  --policy-arn arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess

aws iam attach-role-policy \
  --role-name EventBridgeRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaRole


#############################
create  CodePipelineRole role
#############################
aws iam create-role \
  --role-name CodePipelineRole \
  --assume-role-policy-document file://codepipeline-trust-policy.json

aws iam attach-role-policy \
    --role-name CodePipelineRole \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole