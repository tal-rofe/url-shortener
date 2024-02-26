module "web_app_static" {
  source = "../modules/ssl-static-app"

  common_tags = var.common_tags

  cloudfront_tags = {
    Name  = "${var.project}-CloudFront-Web-App",
    Stack = "Frontend"
  }

  s3_bucket_tags = {
    Name  = "${var.project}-S3-Bucket-Web-App",
    Stack = "Frontend"
  }

  acm_tags = {
    Name  = "${var.project}-ACM-CloudFront-Web-App-Certificate"
    Stack = "Frontend"
  }
}