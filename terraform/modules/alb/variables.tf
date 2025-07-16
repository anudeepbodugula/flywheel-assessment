# Prefix for naming all ALB resources (e.g., dev, prod, app1)
variable "name_prefix" {
  description = "Prefix used for naming ALB resources"
  type        = string
}

# The VPC where the ALB will be deployed
variable "vpc_id" {
  description = "The ID of the VPC where the ALB and SG will be deployed"
  type        = string
}

# Subnets for ALB - these must be public subnets
variable "subnet_ids" {
  description = "List of public subnet IDs for ALB deployment"
  type        = list(string)
}

# Port on which the ALB target group will forward traffic to targets
variable "target_group_port" {
  description = "Port on which the target group forwards traffic to targets"
  type        = number
  default     = 80
}

# Health check path for the target group
variable "health_check_path" {
  description = "Health check path for ALB target group (e.g., /healthz)"
  type        = string
  default     = "/"
}

# Common tags to apply to all resources
variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
}
# ALB Ingress CIDR blocks
variable "alb_ingress_cidr_blocks" {
  description = "List of CIDR blocks that are allowed to access the ALB"
  type        = list(string)
}