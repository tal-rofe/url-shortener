# CloudFront supports US East (N. Virginia) region only
provider "aws" {
  alias  = "cloudfront_certificates_region"
  region = "us-east-1"
}

module "acm_cloudfront" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.0"

  providers = {
    aws = aws.cloudfront_certificates_region
  }

  domain_name         = var.domain_name
  zone_id             = var.zone_id
  wait_for_validation = true
  validation_method   = "DNS"

  tags = merge(var.common_tags, var.acm_tags)
}