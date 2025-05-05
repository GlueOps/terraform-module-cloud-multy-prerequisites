# Remove this file entirely after applying/deploying!
# Removes old items from terraform state without actually deleting them from S3
removed {
  from = aws_s3_object_copy.migrated_objects
}