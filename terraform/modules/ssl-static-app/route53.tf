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

# This bucket redirects www to non-www domains for application
resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "www.${var.domain_name}"

  tags = merge(var.common_tags, var.www_redirect_bucket_tags)
}

resource "aws_s3_bucket_website_configuration" "redirect_config" {
  bucket = aws_s3_bucket.redirect_bucket.bucket

  redirect_all_requests_to {
    host_name = var.domain_name
    protocol  = "https"
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
