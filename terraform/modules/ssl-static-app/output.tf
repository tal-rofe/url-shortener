output "cloudfront_distribution_domain_name" {
  description = "The distribution domain name of deployed CloudFront serving the web application"
  value       = module.cdn.cloudfront_distribution_domain_name
}
