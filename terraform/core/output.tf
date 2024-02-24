output "web_app_cloudfront_distribution_id" {
  description = "The distribution ID of deployed CloudFront web application"
  value       = module.web_app_static.cloudfront_distribution_id
}
