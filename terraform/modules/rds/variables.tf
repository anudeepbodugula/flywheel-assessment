# General Tags for all resources
variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}

# Name prefix for identifying resources
variable "name" {
  type        = string
  description = "Name prefix to use for resources (e.g., project or environment name)"
}

# VPC ID to attach security group
variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS resources will be deployed"
}

# Subnets for RDS Subnet Group (should be private subnets)
variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the DB subnet group"
}

# CIDR blocks allowed to access PostgreSQL (e.g., app or bastion IP ranges)
variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the PostgreSQL database"
}

# PostgreSQL engine version
variable "engine_version" {
  type        = string
  default     = "15.7"
  description = "The version of PostgreSQL to use"
}

# DB instance class (e.g., db.t3.micro for test/dev or db.m5.large for prod)
variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The instance type of the RDS database"
}

# Initial allocated storage in GB
variable "allocated_storage" {
  type        = number
  default     = 20
  description = "Initial amount of storage allocated for the DB (in GB)"
}

# Maximum storage in GB (for autoscaling)
variable "max_allocated_storage" {
  type        = number
  default     = 100
  description = "Maximum allocated storage for autoscaling (in GB)"
}

# PostgreSQL master username
variable "username" {
  type        = string
  description = "Username for the PostgreSQL master user"
  sensitive   = true
}

# PostgreSQL master password
variable "password" {
  type        = string
  description = "Password for the PostgreSQL master user"
  sensitive   = true
}