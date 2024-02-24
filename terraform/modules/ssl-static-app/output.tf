output "cloudfront_distribution_id" {
  description = "The distribution ID of deployed CloudFront serving the web application"
  value       = module.cdn.cloudfront_distribution_id
}
