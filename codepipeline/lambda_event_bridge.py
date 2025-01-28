import json
import boto3

# Initialize the SNS client
sns_client = boto3.client('sns')

# Replace with your SNS topic ARN
SNS_TOPIC_ARN = "arn:aws:sns:eu-west-2:908027384199:Mflask-memcached-SNSTopic"

def lambda_handler(event, context):
    print("Pipeline Failure Event Received")
    print(json.dumps(event, indent=2))
    
    try:
        pipeline_name = event['detail']['pipeline']
        state = event['detail']['state']
        
        # Check if the pipeline state is "FAILED"
        if state == "FAILED":
            print(f"Pipeline {pipeline_name} failed!")
            
            # Construct the notification message
            message = {
                "pipeline": pipeline_name,
                "state": state,
                "details": event
            }
            
            # Publish the notification to the SNS topic
            response = sns_client.publish(
                TopicArn=SNS_TOPIC_ARN,
                Message=json.dumps(message),
                Subject=f"Pipeline Failure: {pipeline_name}"
            )
            
            print(f"Notification sent to SNS. Message ID: {response['MessageId']}")
    
    except KeyError as e:
        print(f"KeyError: {str(e)}")
        return {"statusCode": 500, "body": f"KeyError: {str(e)}"}
    except Exception as e:
        print(f"Error: {str(e)}")
        return {"statusCode": 500, "body": f"Error: {str(e)}"}
    
    return {"statusCode": 200, "body": "Processed"}
