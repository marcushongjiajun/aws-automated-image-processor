# 1. Define WHO can use this role (Trust Policy)
data "aws_iam_policy_document" "app_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com", # For Fargate
      ]
    }
  }
}

# 2. Create the Role
resource "aws_iam_role" "app_role" {
  name               = "image-processor-service-role"
  assume_role_policy = data.aws_iam_policy_document.app_trust_policy.json
}

# 3. Create a STANDALONE Managed Policy that defines WHAT the role can do (Permissions Policy)
resource "aws_iam_policy" "s3_access" {
  name        = "S3AccessPolicy"
  description = "Allows image processor to access specific S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.upload_bucket.arn,
          "${aws_s3_bucket.upload_bucket.arn}/*",
          aws_s3_bucket.processed_bucket.arn,
          "${aws_s3_bucket.processed_bucket.arn}/*"
        ]
      }
    ]
  })
}

# 4. ATTACH the policy to the Role
resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}