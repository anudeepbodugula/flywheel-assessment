# Configure the AWS provider
provider "aws" {
  region = var.region
}

# VPC Module: Creates VPC, subnets, NAT gateway, and S3 endpoint
module "vpc" {
  source = "./modules/vpc"

  region                = var.region
  environment           = var.environment
  common_tags           = var.common_tags

  cidr_block            = var.vpc_cidr_block
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  availability_zones    = var.availability_zones

  enable_nat_gateway    = var.enable_nat_gateway
  enable_s3_endpoint    = var.enable_s3_endpoint
}

# EKS Module: Provisions an EKS cluster and node groups
module "eks" {
  source          = "./modules/eks"

  cluster_name    = "${var.project}-${var.environment}-eks-cluster"
  cluster_version = var.cluster_version 
  subnet_ids      = module.vpc.private_subnet_ids
  node_groups     = var.node_groups
  tags            = var.common_tags
  environment     = var.environment
}

# Security Group Module: Creates security groups for ALB and EKS nodes
module "sg" {
  source = "./modules/sg"

  name_prefix              = "${var.project}-${var.environment}"
  vpc_id                   = module.vpc.vpc_id
  alb_ingress_cidr_blocks  = var.alb_ingress_cidr_blocks
  eks_node_subnet_cidrs    = module.vpc.public_subnet_cidrs
  app_port                 = var.app_port
  tags                     = var.common_tags
}


# S3 Module: Provisions an S3 bucket with optional bucket policy and VPC endpoint
module "s3" {
  source = "./modules/s3"

  bucket_name          = "${var.project}-${var.environment}-app-bucket"
  vpc_id               = module.vpc.vpc_id
  region               = var.region
  route_table_ids      = module.vpc.private_route_table_ids
  tags                 = var.common_tags
  enable_bucket_policy = var.enable_bucket_policy
}

# RDS Module: Provisions an RDS instance in private subnets
module "rds" {
  source = "./modules/rds"

  name                  = "${var.project}-${var.environment}-db"
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage                                        
  username              = var.username
  password              = var.password
  subnet_ids            = module.vpc.private_subnet_ids
  vpc_id                = module.vpc.vpc_id
  allowed_cidr_blocks   = module.vpc.private_subnet_cidrs
  tags                  = var.common_tags
}

# ALB Module: Provisions an Application Load Balancer in public subnets
module "alb" {
  source = "./modules/alb"

  name_prefix             = "${var.project}-${var.environment}"
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.public_subnet_ids
  alb_ingress_cidr_blocks = var.alb_ingress_cidr_blocks
  target_group_port       = var.app_port                
  health_check_path       = "/"                       
  tags                    = var.common_tags
}