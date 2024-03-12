module "s3_store_url_lambda_layer_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"

  acl                      = "private"
  force_destroy            = true
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Store-URL-Lambda-Layer-Bucket-Storage"
      Stack = "Backend"
    }
  )
}
