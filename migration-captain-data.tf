
locals {
  source_bucket_for_captain_data = "${local.bucket_name}-primary"
}

data "aws_s3_objects" "captain_data" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters

  bucket = local.source_bucket_for_captain_data
  prefix = "${aws_route53_zone.clusters[each.key].name}/"
}


locals {
  # Collect all found object keys from all data source instances
  existing_object_keys_list = flatten([
    # Iterate over the *values* of the map created by the data source's for_each
    for cluster_data in values(data.aws_s3_objects.captain_data) :
    # Access the 'keys' attribute for each data source result
    cluster_data.keys
    # Include the keys list ONLY if the data source instance found any keys
    if length(cluster_data.keys) > 0
  ])

  # Convert the list of keys into a set for use in for_each
  existing_object_keys_set = toset(local.existing_object_keys_list)
}

# Resource to copy the object from the source bucket for each key that exists
# to the destination bucket.
resource "aws_s3_object_copy" "migrated_objects" {
  provider = aws.clientaccount
  for_each = local.existing_object_keys_set

  source = "${local.source_bucket_for_captain_data}/${each.key}"
  bucket = module.common_s3_v2.s3_multi_region_access_point_arn

  key = each.key
}


## Delete above and uncomment after migration of data
#removed {
#  from = aws_s3_object_copy.migrated_objects
#}