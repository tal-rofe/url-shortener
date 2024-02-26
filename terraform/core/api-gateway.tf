module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "url-shortener-api-gateway"
  description   = "API gateway for shortener URL"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["Content-Type"]
    allow_methods = ["POST"]
    allow_origins = [module.web_app_static.cloudfront_distribution_domain_name]
  }

  integrations = {
    "POST /api/shortener" = {
      lambda_arn             = aws_lambda_function.store_url_lambda.arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-API-Gateway"
      Stack = "Backend"
    }
  )
}