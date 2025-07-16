variable "name_prefix" {
  type        = string
  description = "Prefix for security group names"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "alb_ingress_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access ALB and EKS from ALB"
}

variable "eks_node_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs of EKS private subnets for RDS access"
}

variable "app_port" {
  type        = number
  description = "Port application listens on (for ALB to EKS)"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}