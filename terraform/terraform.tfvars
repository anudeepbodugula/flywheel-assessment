# General
project     = "flywheel-assessment"
environment = "dev"
region      = "ca-central-1"

# Tags
common_tags = {
  Project     = "flywheel-assessment"
  Environment = "dev"
  Owner       = "anudeep"
  ManagedBy   = "Terraform"
}

# VPC Configuration
vpc_cidr_block         = "10.0.0.0/16"
public_subnet_cidr     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr    = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones     = ["ca-central-1a", "ca-central-1b"]
enable_nat_gateway     = true
enable_s3_endpoint     = true

# ALB / App
alb_ingress_cidr_blocks = ["0.0.0.0/0"]
app_port                = 3000

# EKS Cluster
cluster_version = "1.29"

node_groups = {
  default = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    scaling_config = {
      desired_size = 2
      min_size     = 1
      max_size     = 3
    }
    disk_size = 20
    ami_type  = "AL2_x86_64"
  }
}

# RDS
username            = "flywheeluser"
password            = "SuperSecurePassword123!"  # Replace in production
engine_version         = "15.7"
instance_class         = "db.t3.medium"
allocated_storage      = 20
max_allocated_storage  = 100

# S3 Bucket
enable_bucket_policy = false  # Set to true if you want to enable bucket policy