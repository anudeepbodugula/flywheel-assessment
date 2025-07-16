output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.s3_bucket_application.id
}

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.s3_bucket_application.arn
}

output "s3_bucket_endpoint_id" {
  description = "ID of the VPC S3 Gateway endpoint"
  value       = aws_vpc_endpoint.s3_gateway_endpoint.id
}