resource "aws_s3control_multi_region_access_point" "s3_multi_region_access_point" {
  provider = aws.primaryregion

  details {
    name = random_uuid.s3_multi_region_access_point.result

    region {
      bucket = aws_s3_bucket.primary.id
    }

    region {
      bucket = aws_s3_bucket.replica.id
    }

    public_access_block {
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    }
  }
}

output "s3_multi_region_access_point_arn" {
  value = aws_s3control_multi_region_access_point.s3_multi_region_access_point.arn
}



resource "random_uuid" "s3_multi_region_access_point" {
}