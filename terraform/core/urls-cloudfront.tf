module "urls_cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.3.2"

  comment                       = "CloudFront for caching stored URLs in S3 bucket"
  is_ipv6_enabled               = true
  price_class                   = "PriceClass_100"
  create_origin_access_identity = true
  aliases                       = ["u.${var.domain_name}"]

  origin_access_identities = {
    s3_identity = "S3 dedicated for redirecting clients' URLs"
  }

  origin = {
    s3_identity = {
      domain_name = module.urls_s3_bucket.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_identity"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_identity"
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 5400
    min_ttl                = 3600
    max_ttl                = 7200
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    query_string           = true
  }

  viewer_certificate = {
    acm_certificate_arn = module.cloudfronts_acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Client-URLs-CloudFront"
      Stack = "Backend"
    }
  )
}
