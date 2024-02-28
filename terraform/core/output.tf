output "web_application_s3_bucket" {
  description = "The deployed S3 bucket name of web application"
  value       = module.web_app_static.s3_bucket_name
}

output "cloudfront_distribution_id" {
  description = "The distribution identifier of deployed CloudFront serving the web application"
  value       = module.web_app_static.cloudfront_distribution_id
}