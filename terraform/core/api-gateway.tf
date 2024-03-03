module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name                        = "url-shortener-api-gateway"
  description                 = "API gateway for shortener URL"
  protocol_type               = "HTTP"
  domain_name                 = "api.${var.domain_name}"
  domain_name_certificate_arn = module.api_gateway_acm.acm_certificate_arn

  cors_configuration = {
    allow_headers = ["Content-Type"]
    allow_methods = ["POST"]
    allow_origins = ["https://${var.domain_name}"]
  }

  integrations = {
    "POST /shortener" = {
      lambda_arn             = aws_lambda_function.store_url_lambda.arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }

  domain_name_tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-API-Gateway-Domain"
      Stack = "Backend"
    }
  )

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-API-Gateway"
      Stack = "Backend"
    }
  )
}