module "api_gateway_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

  domain_name               = var.domain_name
  zone_id                   = data.aws_route53_zone.primary.zone_id
  subject_alternative_names = ["api.${var.domain_name}"]
  wait_for_validation       = true
  validation_method         = "DNS"

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-API-Gateway-ACM"
      Stack = "Backend"
    }
  )
}
