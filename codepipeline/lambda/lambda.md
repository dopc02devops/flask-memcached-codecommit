
###########################
Deploy lambda function
###########################
zip function.zip pipeline_failure_handler.py
zip function_event_bridge.zip lambda_event_bridge.py (EventBridge)

Deploy the Lambda Function
###########################
aws lambda create-function \
    --function-name PipelineFailureHandler \
    --runtime python3.9 \
    --role arn:aws:iam::908027384199:role/LambdaExecutionRole \
    --handler pipeline_failure_handler.lambda_handler \
    --zip-file fileb://function.zip \
    --timeout 60 \
    --memory-size 128 \
    --region eu-west-2

aws lambda create-function \
    --function-name PipelineFailureHandlerEventBidge \
    --runtime python3.9 \
    --role arn:aws:iam::908027384199:role/LambdaExecutionRole \
    --handler lambda_event_bridge.lambda_handler \
    --zip-file fileb://function_event_bridge.zip \
    --timeout 60 \
    --memory-size 128 \
    --region eu-west-2

get function
############
aws lambda get-function --function-name PipelineFailureHandler
aws lambda get-function --function-name PipelineFailureHandlerEventBidge

update function
###############
aws lambda update-function-code \
  --function-name my-pipeline-failure-handler \
  --zip-file fileb://lambda_function.zip


Verify and Test
###############
aws lambda invoke \
    --function-name PipelineFailureHandler \
    --cli-binary-format raw-in-base64-out \
    --payload file://payload.json \
    output.json