"""This code would have been used if we were to just pass messages internally, not the the clients."""
# def entrypoint(event, context):
#     return {'Status': 'Success'}

import boto3
import os

SNS_TOPIC = os.environ['SNS_TOPIC_ARN']
MESSAGE = "Hello, world!"


def entrypoint(event, context):
    """Send message to the SNS topic with a specific body."""
    client = boto3.client('sns')
    client.publish(TopicArn=SNS_TOPIC,
                   Message=MESSAGE,
                   Subject="Subject wasn't included in the specs"
                   )
    return "Success"
