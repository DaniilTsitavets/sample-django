resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
  numeric  = true
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name != null ? var.s3_bucket_name : "task3-bucket-${random_string.suffix.result}"
}