resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "upload_bucket" {
  bucket = "mhjj-uploads-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket" "processed_bucket" {
  bucket = "mhjj-processed-${random_id.bucket_suffix.hex}"
}

# Create a lifecycle rule for both buckets, to delete files after one day
resource "aws_s3_bucket_lifecycle_configuration" "cleanup" {
  # User a map with static keeys ("upload" and "processed")
  for_each = {
    upload = aws_s3_bucket.upload_bucket.id
    processed = aws_s3_bucket.processed_bucket.id
  }
  
  bucket = each.value # takes the ID from the list above

  rule {
    id = "auto-delete-old-files"
    status = "Enabled"

    # Add an empty filter to apply to the entire bucket
    filter {}

    expiration {
      days = 1
    }
  }
}