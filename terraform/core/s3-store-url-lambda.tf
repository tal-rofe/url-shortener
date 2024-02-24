module "s3_store_url_lambda_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.2"

  acl           = "private"
  force_destroy = true

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-Lambda-Bucket-Storage"
      Stack = "Backend"
    }
  )
}
