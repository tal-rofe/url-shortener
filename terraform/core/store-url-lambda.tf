data "aws_iam_policy_document" "store_url_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda_store_url" {
  name               = "IAM-for-lambda-store-url"
  assume_role_policy = data.aws_iam_policy_document.store_url_lambda_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-Lambda-IAM-Role"
      Stack = "Backend"
    }
  )
}

data "aws_iam_policy" "store_url_lambda_basic_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "store_url_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda_store_url.id
  policy_arn = data.aws_iam_policy.store_url_lambda_basic_execution_policy.arn
}

data "archive_file" "lambda_store_url_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../functions/store-url/build"
  output_path = "${path.module}/../store-url.zip"
}

resource "aws_s3_object" "store_url_lambda_s3_object" {
  bucket = module.s3_store_url_lambda_bucket.s3_bucket_id
  key    = "store-url.zip"
  source = data.archive_file.lambda_store_url_zip.output_path
  etag   = filemd5(data.archive_file.lambda_store_url_zip.output_path)

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-Lambda-S3-Object"
      Stack = "Backend"
    }
  )
}

resource "aws_lambda_function" "store_url_lambda" {
  function_name    = var.store_url_lambda_function_name
  role             = aws_iam_role.iam_for_lambda_store_url.arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.lambda_store_url_zip.output_base64sha256
  s3_bucket        = module.s3_store_url_lambda_bucket.s3_bucket_id
  s3_key           = aws_s3_object.store_url_lambda_s3_object.key
  depends_on       = [aws_cloudwatch_log_group.store_url_cloudwatch_log_group]

  environment {
    variables = {
      S3_BUCKET = module.s3_store_url_lambda_bucket.s3_bucket_id
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-Lambda-Function"
      Stack = "Backend"
    }
  )
}
