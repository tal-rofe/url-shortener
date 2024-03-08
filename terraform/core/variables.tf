variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  type        = string
}

variable "domain_name" {
  description = "Domain name of application"
  type        = string
}

variable "store_url_lambda_function_name" {
  description = "Name of the lambda function dedicated for storing URLs"
  type        = string
}

variable "common_tags" {
  description = "A map of common tags to add to all resources"
  type        = map(string)
}
