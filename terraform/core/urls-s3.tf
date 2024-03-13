data "aws_iam_policy_document" "urls_s3_policy" {
  version = "2012-10-17"

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.urls_s3_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = module.urls_cloudfront.cloudfront_origin_access_identity_iam_arns
    }
  }

  statement {
    actions   = ["s3:PutObject", "s3:PutObjectAcl"]
    resources = ["${module.urls_s3_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.iam_for_lambda_store_url.arn]
    }
  }
}

module "urls_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"

  acl                      = "private"
  force_destroy            = true
  attach_policy            = true
  policy                   = data.aws_iam_policy_document.urls_s3_policy.json
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"
  website = {
    index_document = {
      suffix = "index.html"
    }

    error_document = {
      key = "error.html"
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.project}-Client-URLs-S3-Bucket"
      Stack = "Backend"
    }
  )
}


