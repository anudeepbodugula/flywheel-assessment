output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "List of private subnet IDs"
}

output "eks_cluster_name" {
  value       = module.eks.eks_cluster_name
  description = "EKS Cluster Name"
}

output "rds_endpoint" {
  value       = module.rds.db_instance_endpoint
  description = "RDS PostgreSQL Endpoint"
}

output "s3_bucket_name" {
  value       = module.s3.s3_bucket_name
  description = "Name of the application S3 bucket"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "ALB DNS Name"
}

output "s3_bucket_endpoint_id" {
  value = module.s3.s3_bucket_endpoint_id
}