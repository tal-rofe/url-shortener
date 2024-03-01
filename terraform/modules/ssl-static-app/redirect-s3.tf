# This bucket redirects www to non-www domains for application
resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "www.${var.domain_name}"

  tags = merge(var.common_tags, var.www_redirect_bucket_tags)
}

resource "aws_s3_bucket_website_configuration" "redirect_config" {
  bucket = aws_s3_bucket.redirect_bucket.bucket

  redirect_all_requests_to {
    host_name = var.domain_name
    protocol  = "https"
  }
}