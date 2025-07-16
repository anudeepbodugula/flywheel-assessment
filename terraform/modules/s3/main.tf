# Create an S3 bucket
resource "aws_s3_bucket" "s3_bucket_application" {
    bucket = var.bucket_name
    force_destroy = true

    tags = var.tags
}
# Enable server-side encryption with AWS with AES-256
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
    bucket = aws_s3_bucket.s3_bucket_application.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "s3_bucket_block_public" {
    bucket = aws_s3_bucket.s3_bucket_application.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# Enable versioning for rollback and object history
resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
    bucket = aws_s3_bucket.s3_bucket_application.id

    versioning_configuration {
        status = "Enabled"
    }
}

# Attach custom policy to the S3 bucket (only if needed)
resource "aws_s3_bucket_policy" "s3_bucket_policy_custom" {
    count = var.enable_bucket_policy ? 1 : 0
    bucket = aws_s3_bucket.s3_bucket_application.id
    policy = var.bucket_policy
}

# create a Gateway S3 endpoint
resource "aws_vpc_endpoint" "s3_gateway_endpoint" {
    vpc_id = var.vpc_id
    service_name = "com.amazonaws.${var.region}.s3"
    vpc_endpoint_type = "Gateway"
    route_table_ids = var.route_table_ids

    tags = var.tags
    depends_on = [aws_s3_bucket.s3_bucket_application]
}
