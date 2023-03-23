resource "aws_s3_bucket" "primary" {
  provider      = aws.primaryregion
  bucket        = "${var.bucket_name}-primary"
  force_destroy = var.this_is_development ? true : false
}
output "primary_s3_bucket_arn" {
  value = aws_s3_bucket.primary.arn
}

output "primary_s3_bucket_id" {
  value = aws_s3_bucket.primary.id
}

resource "aws_s3_bucket_acl" "primary" {
  provider = aws.primaryregion
  bucket   = aws_s3_bucket.primary.id
  acl      = "private"
}

resource "aws_s3_bucket_versioning" "primary" {
  provider = aws.primaryregion
  bucket   = aws_s3_bucket.primary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "primary" {
  provider = aws.primaryregion
  bucket   = aws_s3_bucket.primary.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "primary" {
  provider   = aws.primaryregion
  depends_on = [aws_s3_bucket_versioning.primary]
  bucket     = aws_s3_bucket.primary.id
  rule {
    id = "expire_non_current_version"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = var.this_is_development ? 1 : 90
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "primary" {
  provider = aws.primaryregion
  bucket   = aws_s3_bucket.primary.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}