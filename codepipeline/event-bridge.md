
# AWS EventBridge is a serverless event bus that helps applications communicate with each other using 
# events. It allows you to detect changes in AWS services (like CodePipeline failures) and trigger 
# actions (like running a Lambda function, sending an SNS notification, or invoking Step Functions)

###########################
Define the EventBridge Rule
###########################

aws events put-rule \
    --name "PipelineFailureRule" \
    --event-pattern '{
        "source": ["aws.codepipeline", "myapp.events"],
        "detail-type": ["CodePipeline Pipeline Execution State Change"],
        "detail": {
            "state": ["FAILED"]
        }
    }' \
    --description "Triggers Lambda on pipeline failure" \
    --role-arn "arn:aws:iam::908027384199:role/EventBridgeRole" \
    --event-bus-name default
# source: "myapp.events" is used for testing or invoking lambda
# This AWS EventBridge rule (PipelineFailureRule) is designed to trigger an action whenever an AWS 
# CodePipeline execution fails

###########################################
Attach Lambda to be triggerred by the rule
###########################################
aws events put-targets \
    --rule PipelineFailureRule \
    --targets '[
        {
            "Id": "LambdaTarget",
            "Arn": "arn:aws:lambda:eu-west-2:908027384199:function:PipelineFailureHandlerEventBidge"
        }
    ]'

#################################################
Grant EventBridge Permission to Invoke the Lambda
#################################################
aws lambda add-permission \
    --function-name "PipelineFailureHandlerEventBidge" \
    --statement-id "AllowEventBridgeInvocation" \
    --action "lambda:InvokeFunction" \
    --principal "events.amazonaws.com" \
    --source-arn "arn:aws:events:eu-west-2:908027384199:rule/PipelineFailureRule"

aws events list-event-sources
aws events list-event-buses
aws events describe-rule --name PipelineFailureRule
aws events list-targets-by-rule --rule PipelineFailureRule
aws lambda get-policy --function-name PipelineFailureHandlerEventBidge

################
Test EventBridge
################
aws events put-events \
  --entries '[
    {
      "Source": "myapp.events",
      "DetailType": "CodePipeline Pipeline Execution State Change",
      "Detail": "{\"state\": \"FAILED\", \"pipeline\": \"MyTestPipeline\"}",
      "EventBusName": "default"
    }
  ]'


