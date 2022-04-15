####### LAMBDA IAM #######
resource "aws_iam_role" "mail_lambda_iam" {
  name = "mail_lambda_iam"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
      {
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "arn:aws:sns:*:*:*"
        }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.mail_lambda_iam.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

####### SNS IAM #######
data "aws_iam_policy_document" "get_sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Publish"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.get_sns_topic.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_policy" "get_sns_policy" {
  arn    = aws_sns_topic.get_sns_topic.arn
  policy = data.aws_iam_policy_document.get_sns_topic_policy.json
}