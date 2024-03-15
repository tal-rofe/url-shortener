resource "aws_cloudfront_function" "redirect_url_lambda_edge" {
  name    = "redirect-url-lambda-edge"
  comment = "Lambda@Edge function to redirect hashed URLs to original"
  runtime = "cloudfront-js-2.0"
  code    = file("${path.module}/../../functions/redirect-url/build/index.js")
}

resource "aws_cloudfront_key_value_store" "redirect_url_key_value_store" {
  name    = "redirect-url-key-value-store"
  comment = "Key Value Store for Lambda@Edge of url redirect"
}