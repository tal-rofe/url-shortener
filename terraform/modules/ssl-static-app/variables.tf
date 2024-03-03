variable "domain_name" {
  description = "The domain name of the application"
  type        = string
}

variable "zone_id" {
  description = "The zone identifier to set domain of the application in"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The certificate ARN for CloudFront"
  type        = string
}

variable "common_tags" {
  description = "The tags for all created resources"
  type        = map(string)
  default     = {}
}

variable "cloudfront_tags" {
  description = "The tags for CloudFront resource"
  type        = map(string)
}

variable "s3_bucket_tags" {
  description = "The tags for S3 bucket resource"
  type        = map(string)
}

variable "acm_tags" {
  description = "The tags for ACM resource"
  type        = map(string)
}

variable "www_redirect_bucket_tags" {
  description = "The tags for redirect bucket resource"
  type        = map(string)
}
