resource "aws_route53_zone" "primary" {
  name          = var.domain_name
  comment       = "Hosted Zone for URL shortener application, managed by Terraform"
  force_destroy = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-Route53-Zone",
    }
  )
}

resource "aws_route53_record" "api_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.api_gateway.apigatewayv2_domain_name_configuration[0].target_domain_name
    zone_id                = module.api_gateway.apigatewayv2_domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "urls_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.urls_cloudfront.cloudfront_distribution_domain_name
    zone_id                = module.urls_cloudfront.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = true
  }
}