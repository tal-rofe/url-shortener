output "web_app_cloudfront_distribution_domain_name" {
  description = "The distribution domain name of deployed CloudFront serving the web application"
  value       = module.web_app_static.cloudfront_distribution_domain_name
}

output "urls_cloudfront_distribution_domain_name" {
  description = "The distribution domain name of deployed CloudFront serving the web application"
  value       = module.web_app_static.cloudfront_distribution_domain_name
}

output "api_gateway_endpoint" {
  description = "The API gateway endpoint for clients to submit their URLs"
  value       = module.api_gateway.apigatewayv2_api_api_endpoint
}