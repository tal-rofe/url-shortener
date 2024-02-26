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

variable "not_found_file_path" {
  description = "The file to load when requests resource (page) not found"
  type        = string
  default     = "/index.html"
}
