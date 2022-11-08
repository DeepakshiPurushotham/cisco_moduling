#####  S3 bucket creation #####
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.bucket_name

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "s3bucket-acl" {
  bucket = aws_s3_bucket.s3bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      #kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "AES256"
    }
  }
}