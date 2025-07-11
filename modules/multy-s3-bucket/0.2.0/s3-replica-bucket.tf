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
    for_each = var.cluster_zone_names
    content {
      id = "${rule.value}_expire_old_vault_backups"

      filter {
        prefix = "${rule.value}/hashicorp-vault-backups/"
      }

      expiration {
        days = var.this_is_development ? 50 : 180
      }

      transition {
        days          = var.this_is_development ? 30 : 60
        storage_class = "GLACIER"
      }

      noncurrent_version_expiration {
        noncurrent_days = var.this_is_development ? 30 : 100
      }

      noncurrent_version_transition {
        noncurrent_days = var.this_is_development ? 15 : 30
        storage_class   = "GLACIER"
      }

      status = "Enabled"
    }

  }

  dynamic "rule" {
    for_each = var.cluster_zone_names
    content {
      id = "${rule.value}_expire_old_tls_backups"

      filter {
        prefix = "${rule.value}/tls-cert-backups/"
      }

      expiration {
        days = var.this_is_development ? 50 : 180
      }

      transition {
        days          = var.this_is_development ? 30 : 60
        storage_class = "GLACIER"
      }

      noncurrent_version_expiration {
        noncurrent_days = var.this_is_development ? 30 : 100
      }

      noncurrent_version_transition {
        noncurrent_days = var.this_is_development ? 15 : 30
        storage_class   = "GLACIER"
      }

      status = "Enabled"
    }

  }

  dynamic "rule" {
    for_each = var.cluster_zone_names
    content {
      id = "${rule.value}_expire_transition_vault"
      filter {
        prefix = "${rule.value}/${local.vault_backup_s3_key_prefix}/"
      }

      expiration {
        days = var.this_is_development ? 50 : 180
      }

      transition {
        days          = var.this_is_development ? 30 : 60
        storage_class = "GLACIER"
      }

      noncurrent_version_expiration {
        noncurrent_days = var.this_is_development ? 30 : 100
      }

      noncurrent_version_transition {
        noncurrent_days = var.this_is_development ? 15 : 30
        storage_class   = "GLACIER"
      }

      status = "Enabled"
    }


  }

  dynamic "rule" {
    for_each = var.cluster_zone_names

    content {
      id = "${rule.value}_expire_transition_tls"
      filter {
        prefix = "${rule.value}/${local.tls_cert_backup_s3_key_prefix}/"
      }

      expiration {
        days = var.this_is_development ? 50 : 180
      }

      transition {
        days          = var.this_is_development ? 30 : 60
        storage_class = "GLACIER"
      }

      noncurrent_version_expiration {
        noncurrent_days = var.this_is_development ? 30 : 100
      }

      noncurrent_version_transition {
        noncurrent_days = var.this_is_development ? 15 : 30
        storage_class   = "GLACIER"
      }

      status = "Enabled"
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