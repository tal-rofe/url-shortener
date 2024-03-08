resource "aws_cloudwatch_log_group" "store_url_cloudwatch_log_group" {
  name              = "/aws/lambda/${var.store_url_lambda_function_name}"
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
