resource "aws_s3_bucket" "primary" {
  provider      = aws.primaryregion
  bucket        = length("${var.bucket_name}-primary") > 63 ? "bucket-${substr(sha256("${var.bucket_name}-primary"), 0, 51)}" : "${var.bucket_name}-primary"
  force_destroy = var.this_is_development ? true : false
}
output "primary_s3_bucket_arn" {
  value = aws_s3_bucket.primary.arn
}

output "primary_s3_bucket_id" {
  value = aws_s3_bucket.primary.id
}

resource "aws_s3_bucket_versioning" "primary" {
  provider = aws.primaryregion
  bucket   = aws_s3_bucket.primary.id
  versioning_configuration {
    status = var.enable_replication_and_versioning ? "Enabled" : "Suspended"
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
    id = "expire_transition_vault"

    filter {
      prefix = "backups_with_expiration_enabled/hashicorp-vault-backups/"
    }

    expiration {
      days = 180
    }

    transition {
      days          = var.this_is_development ? 30 : 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 180
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }

  rule {
    id = "expire_transition_tls"

    filter {
      prefix = "backups_with_expiration_enabled/tls-cert-backups/"
    }

    expiration {
      days = 180
    }

    transition {
      days          = var.this_is_development ? 20 : 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 180
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
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
