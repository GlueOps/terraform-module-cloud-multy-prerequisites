resource "aws_s3_bucket" "replica" {
  provider      = aws.replicaregion
  bucket        = random_uuid.replica.result
  force_destroy = var.this_is_development ? true : false

  tags = {
    Name        = "${var.tenant_key}-replica"
    tenant_name = var.tenant_key
  }

}

resource "aws_s3_bucket_versioning" "replica" {
  provider = aws.replicaregion
  bucket   = aws_s3_bucket.replica.id
  versioning_configuration {
    status = "Enabled"
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
  count      = length(var.cluster_zone_names) > 0 ? 1 : 0

  dynamic "rule" {
    for_each = toset(local.backup_prefixes)
    content {
      id     = "${replace(rule.value, "/", "_")}lifecycle"
      status = "Enabled"

      filter {
        and {
          prefix                   = rule.value
          object_size_greater_than = 131072 # 128 KB
        }
      }

      transition {
        days          = 1 # Day 1 is safer for replicas
        storage_class = "STANDARD_IA"
      }

      dynamic "transition" {
        for_each = var.this_is_development ? [] : [1]
        content {
          days          = 60
          storage_class = "GLACIER"
        }
      }

      expiration {
        days = local.expire_days
      }

      dynamic "noncurrent_version_transition" {
        for_each = var.this_is_development ? [] : [1]
        content {
          noncurrent_days = local.noncurrent_transition_days
          storage_class   = "GLACIER"
        }
      }

      noncurrent_version_expiration {
        noncurrent_days = local.noncurrent_expire_days
      }

      abort_incomplete_multipart_upload {
        days_after_initiation = 1
      }
    }
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



resource "random_uuid" "replica" {
}