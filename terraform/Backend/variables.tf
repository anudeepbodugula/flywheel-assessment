variable "environment" {
  description = "The environment for which the Terraform state is being managed (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  
}

variable "project" {
  description = "The name of the project for which the Terraform state is being managed"
  type        = string
  default     = "flywheel-assessment"
  
}
variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default = "ca-central-1"  ## Default region, can be overridden by the user
}