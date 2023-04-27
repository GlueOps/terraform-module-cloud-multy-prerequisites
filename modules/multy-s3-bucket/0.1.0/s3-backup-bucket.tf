resource "aws_s3_bucket" "replica" {
  provider      = aws.replicaregion
  bucket        = "${var.bucket_name}-replica"
  force_destroy = var.this_is_development ? true : false
}
output "replica_s3_bucket_arn" {
  value = aws_s3_bucket.replica.arn
}

resource "aws_s3_bucket_versioning" "replica" {
  provider = aws.replicaregion
  bucket   = aws_s3_bucket.replica.id
  versioning_configuration {
    status = var.enable_replication_and_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replica" {
  provider = aws.replicaregion
  bucket   = aws_s3_bucket.replica.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "replica" {
  provider   = aws.replicaregion
  depends_on = [aws_s3_bucket_versioning.replica]
  bucket     = aws_s3_bucket.replica.id
  rule {
    id = "expire_non_current_version"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.this_is_development ? 1 : 90
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "replica" {
  provider = aws.replicaregion
  bucket   = aws_s3_bucket.replica.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
