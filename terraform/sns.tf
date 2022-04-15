resource "aws_sns_topic" "get_sns_topic" {
  name = "get_sns_topic"
}

resource "aws_sns_topic_subscription" "get_sns_subscription" {
  endpoint  = var.subscriber_email
  protocol  = "email"
  topic_arn = aws_sns_topic.get_sns_topic.arn
}
