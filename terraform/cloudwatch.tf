resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.email_sender_lambda.function_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_event_rule" "scheduler_event_rule" {
  name                = "scheduler_event_rule"
  description         = "Trigger every day at 1 AM."
  schedule_expression = "cron(0 1 * * ? *)" # send every day of every month at 1 AM
}

resource "aws_cloudwatch_event_target" "scheduler-event-target" {
  arn  = aws_lambda_function.email_sender_lambda.arn
  rule = aws_cloudwatch_event_rule.scheduler_event_rule.name
}
