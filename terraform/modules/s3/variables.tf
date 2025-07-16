variable "bucket_name" {
  description = "Name of the S3 bucket to be created"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_bucket_policy" {
  description = "Flag to conditionally attach a custom bucket policy"
  type        = bool
  default     = false
}

variable "bucket_policy" {
  description = "Custom bucket policy JSON (used only if enable_bucket_policy is true)"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC ID where the S3 gateway endpoint should be created"
  type        = string
}

variable "region" {
  description = "AWS region for constructing the S3 service endpoint name"
  type        = string
}

variable "route_table_ids" {
  description = "List of route table IDs to associate with the S3 gateway endpoint"
  type        = list(string)
}

variable "enable_s3_endpoint" {
  description = "Flag to enable or disable the creation of the S3 VPC endpoint"
  type        = bool
  default     = true
  
}
variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}