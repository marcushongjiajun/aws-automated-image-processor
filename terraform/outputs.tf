output "upload_bucket_name" {
  description = "S3 bucket for uploading raw images"
  value = aws_s3_bucket.upload_bucket.id
}

output "processed_bucket_name" {
  description = "S3 bucket for processed images"
  value = aws_s3_bucket.processed_bucket.id
}

output "app_role_arn" {
  description = "The ARN of the IAM Role the container will assume"
  value = aws_iam_role.app_role.arn
}