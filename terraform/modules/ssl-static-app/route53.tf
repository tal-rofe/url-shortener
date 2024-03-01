resource "aws_route53_record" "app_record" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.cdn.cloudfront_distribution_domain_name
    zone_id                = module.cdn.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "redirect_route" {
  zone_id = var.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.redirect_config.website_domain
    zone_id                = aws_s3_bucket.redirect_bucket.hosted_zone_id
    evaluate_target_health = true
  }
}
