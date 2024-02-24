variable "stored_urls_s3_bucket_name" {
  description = "Name of the S3 bucket dedicated for storing the URLs"
  type        = string
}

variable "web_app_s3_bucket_name" {
  description = "Name of the S3 bucket dedicated for the web application"
  type        = string
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  type        = string
}

variable "common_tags" {
  description = "A map of common tags to add to all resources"
  type        = map(string)
}
