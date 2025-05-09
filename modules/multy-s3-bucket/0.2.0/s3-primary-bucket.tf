resource "aws_s3_bucket" "primary" {
  provider      = aws.primaryregion
  bucket        = random_uuid.primary.result
  force_destroy = var.this_is_development ? true : false
  tags = {
    Name        = "${var.tenant_key}-primary"
    tenant_name = var.tenant_key

  }
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

  dynamic "rule" {
    for_each = aws_route53_zone.clusters
    content {
      id = "${rule.key}_expire_old_vault_backups"

      filter {
        prefix = "${rule.key}/hashicorp-vault-backups/"
      }

      expiration {
        days = 15
      }

      status = "Enabled"
    }
    
  }

  dynamic "rule" {
    for_each = aws_route53_zone.clusters
    content {
      id = "${rule.key}_expire_old_tls_backups"

      filter {
        prefix = "${rule.key}/tls-cert-backups/"
      }

      expiration {
        days = 15
      }

      status = "Enabled"
    }
   
  }

  dynamic "rule" {
    for_each = aws_route53_zone.clusters
    content {
      id = "${rule.key}_expire_transition_vault"
      filter {
        prefix = "${rule.key}/backups_with_expiration_enabled/hashicorp-vault-backups/"
      }

      expiration {
        days = var.this_is_development ? 50: 180
      }

      transition {
        days          = var.this_is_development ? 30 : 60
        storage_class = "GLACIER"
      }

      noncurrent_version_expiration {
        noncurrent_days = var.this_is_development ? 14 : 180
      }

      noncurrent_version_transition {
        noncurrent_days = var.this_is_development ? 15 : 30
        storage_class   = "GLACIER"
      }

      status = "Enabled"
    }

    
  }

  dynamic "rule" {
    for_each = aws_route53_zone.clusters

    content{
      id = "${rule.key}_expire_transition_tls"
      filter {
        prefix = "${rule.key}/backups_with_expiration_enabled/tls-cert-backups/"
      }

      expiration {
        days = var.this_is_development ? 50: 180
      }

      transition {
        days          = var.this_is_development ? 20 : 60
        storage_class = "GLACIER"
      }

      noncurrent_version_expiration {
        noncurrent_days = var.this_is_development ? 14 : 180
      }

      noncurrent_version_transition {
        noncurrent_days = var.this_is_development ? 15 : 30
        storage_class   = "GLACIER"
      }
      status = "Enabled"

    }
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


resource "random_uuid" "primary" {
}