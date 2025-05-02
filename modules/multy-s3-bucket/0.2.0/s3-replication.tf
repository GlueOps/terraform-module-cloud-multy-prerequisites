resource "random_uuid" "aws_iam_role_replication" {
}

resource "aws_iam_role" "replication" {
  provider = aws.primaryregion
  name     = random_uuid.aws_iam_role_replication.result

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
  tags {
    Name = "tf-role-s3-rplctn-${var.tenant_key}"
  }
}

resource "random_uuid" "aws_iam_policy" {
}

resource "aws_iam_policy" "replication" {
  provider = aws.primaryregion
  name     = random_uuid.aws_iam_policy.result

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.primary.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
         "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.primary.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.replica.arn}/*"
    }
  ]
}
POLICY
  tags {
    Name = "tf-role-s3-rplctn-${var.tenant_key}"
  }
}

resource "aws_iam_role_policy_attachment" "replication" {
  provider   = aws.primaryregion
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider   = aws.primaryregion
  depends_on = [aws_s3_bucket_versioning.replica, aws_s3_bucket_versioning.primary]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.primary.id

  rule {
    id = "replication"
    filter {}

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD"
      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }
      metrics {
        event_threshold {
          minutes = 15
        }
        status = "Enabled"
      }
    }
    delete_marker_replication {
      status = "Enabled"
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "replica" {
  provider   = aws.replicaregion
  depends_on = [aws_s3_bucket_versioning.replica, aws_s3_bucket_versioning.primary]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.replica.id

  rule {
    id = "replication"
    filter {}

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.primary.arn
      storage_class = "STANDARD"
      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }
      metrics {
        event_threshold {
          minutes = 15
        }
        status = "Enabled"
      }
    }
    delete_marker_replication {
      status = "Enabled"
    }
  }

}