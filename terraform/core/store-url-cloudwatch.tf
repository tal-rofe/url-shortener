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

data "aws_iam_policy" "lambda_basic_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_flow_log_cloudwatch" {
  role       = aws_iam_role.iam_for_lambda_store_url.name
  policy_arn = data.aws_iam_policy.lambda_basic_execution_policy.arn
}