### This module sets up AWS resources for Terraform bootstrapping across multiple accounts

# Create Amazon S3 buckets for Terraform state file
resource "aws_s3_bucket" "tfstate" {
  bucket = "terraform-backend-dotnet-demo"
  force_destroy = true

  tags = local.common_tags
}

# Block Amazon S3 Bucket public access
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

