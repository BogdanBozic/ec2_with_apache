
data "archive_file" "lambda_my_function" {
  type             = "zip"
  source_file      = "./mail_sender.py"
  output_file_mode = "0666"
  output_path      = "./mail_sender.py.zip"
}

resource "aws_lambda_function" "email_sender_lambda" {
  filename         = "./mail_sender.py.zip"
  function_name    = "email_sender_lambda"
  role             = aws_iam_role.mail_lambda_iam.arn
  handler          = "mail_sender.entrypoint"
  source_code_hash = filebase64sha256(data.archive_file.lambda_my_function.output_path)
  runtime          = "python3.9"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.get_sns_topic.arn
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_sender_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduler_event_rule.arn
}
