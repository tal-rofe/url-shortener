# CloudFront supports US East (N. Virginia) region only
provider "aws" {
  alias  = "cloudfront_certificates_region"
  region = "us-east-1"
}

module "cloudfronts_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.0"

  providers = {
    aws = aws.cloudfront_certificates_region
  }

  domain_name               = var.domain_name
  zone_id                   = data.aws_route53_zone.primary.zone_id
  wait_for_validation       = true
  validation_method         = "DNS"
  subject_alternative_names = ["u.${var.domain_name}"]

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-ACM-CloudFronts"
      Stack = "Frontend"
    }
  )
}