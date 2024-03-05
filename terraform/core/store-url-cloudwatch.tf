resource "aws_cloudwatch_log_group" "store_url_cloudwatch_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.store_url_lambda.function_name}"
  retention_in_days = 14

  lifecycle {
    prevent_destroy = false
  }

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-CloudWatch-Log-Group"
      Stack = "Backend"
    }
  )
}

resource "aws_iam_policy" "store_url_logging_policy" {
  name = "Store-url-logging-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-Logging-Policy"
      Stack = "Backend"
    }
  )
}

resource "aws_iam_role_policy_attachment" "store_url_logging_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda_store_url.id
  policy_arn = aws_iam_policy.store_url_logging_policy.arn
}