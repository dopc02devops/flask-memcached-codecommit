import boto3
import json
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialise the SNS client
sns_client = boto3.client("sns")
SNS_TOPIC_ARN = "arn:aws:sns:eu-west-2:908027384199:Mflask-memcached-SNSTopic" 


def lambda_handler(event, context):
    """
    Handle pipeline failure notifications.
    """
    logger.info("Received event: %s", json.dumps(event))

    # Extract details from the CodePipeline event
    try:
        pipeline_name = event["detail"]["pipeline"]
        execution_id = event["detail"]["execution-id"]
        stage_name = event["detail"]["stage"]
        action_name = event["detail"]["action"]
        region = event["region"]

        failure_details = event["detail"]["execution-result"]["external-execution-summary"]

        message = (
            f"Pipeline: {pipeline_name}\n"
            f"Execution ID: {execution_id}\n"
            f"Stage: {stage_name}\n"
            f"Action: {action_name}\n"
            f"Region: {region}\n"
            f"Failure Details: {failure_details}"
        )

        # Log the failure details
        logger.error("Pipeline Failure:\n%s", message)

        # Send notification via SNS
        response = sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=f"Pipeline Failure: {pipeline_name}",
            Message=message
        )

        logger.info("SNS notification sent. Response: %s", response)
        return {"statusCode": 200, "body": "Notification sent successfully."}

    except KeyError as e:
        logger.error("Missing expected key in the event data: %s", str(e))
        return {"statusCode": 400, "body": "Event data is incomplete."}

    except Exception as e:
        logger.error("An unexpected error occurred: %s", str(e))
        return {"statusCode": 500, "body": "Internal server error."}
