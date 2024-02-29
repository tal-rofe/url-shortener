# CloudFront supports US East (N. Virginia) region only
provider "aws" {
  alias  = "cloudfront_certificates_region"
  region = "us-east-1"
}

module "urls_acm_cloudfront" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.0"

  providers = {
    aws = aws.cloudfront_certificates_region
  }

  zone_id             = aws_route53_zone.primary.zone_id
  validation_method   = "DNS"
  wait_for_validation = true

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Client-URLs-ACM"
      Stack = "Backend"
    }
  )
}