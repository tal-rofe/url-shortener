data "archive_file" "lambda_layer_store_url_zip" {
  type        = "zip"
  source_dir  = "${dirname(path.module)}/artifacts/store-url/nodejs"
  output_path = "${dirname(path.module)}/artifacts/store-url/nodejs.zip"
}

resource "aws_s3_object" "store_url_lambda_layer_s3_object" {
  bucket = module.s3_store_url_lambda_layer_bucket.s3_bucket_id
  key    = "nodejs.zip"
  source = data.archive_file.lambda_layer_store_url_zip.output_path
  etag   = filemd5(data.archive_file.lambda_layer_store_url_zip.output_path)

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-Lambda-Layer-S3-Object"
      Stack = "Backend"
    }
  )
}

resource "aws_lambda_layer_version" "store_url_lambda_layer" {
  layer_name          = "store-url-lambda-layer-node-modules"
  description         = "This layer contains node modules required for the main lambda function to run"
  s3_bucket           = module.s3_store_url_lambda_layer_bucket.s3_bucket_id
  s3_key              = aws_s3_object.store_url_lambda_layer_s3_object.key
  source_code_hash    = data.archive_file.main.output_base64sha256
  compatible_runtimes = ["nodejs20.x"]
}