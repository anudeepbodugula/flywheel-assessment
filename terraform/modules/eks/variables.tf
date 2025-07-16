# Cluster Name
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# EKS Version
variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

# Subnet IDs (Public and Private)
variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster (public and/or private)"
  type        = list(string)
}

# Environment (dev/stage/prod)
variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)"
  type        = string
}

# Common Tags
variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

# Node group definition map
variable "node_groups" {
  description = "Map of node group configurations"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    disk_size = number
    ami_type  = string
  }))
}