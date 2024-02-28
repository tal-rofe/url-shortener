output "cloudfront_distribution_domain_name" {
  description = "The distribution domain name of deployed CloudFront serving the web application"
  value       = module.cdn.cloudfront_distribution_domain_name
}

output "cloudfront_distribution_id" {
  description = "The distribution identifier of deployed CloudFront serving the web application"
  value       = module.cdn.cloudfront_distribution_id
}

output "s3_bucket_name" {
  description = "The deployed S3 bucket name of static application"
  value       = module.s3_bucket.s3_bucket_id
}