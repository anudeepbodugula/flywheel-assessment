# Output: ALB DNS name
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.application_alb.dns_name
}

# Output: ALB ARN
output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.application_alb.arn
}

# Output: Target Group ARN
output "target_group_arn" {
  description = "The ARN of the ALB Target Group"
  value       = aws_lb_target_group.alb_target_group.arn
}

# Output: Security Group ID of the ALB
output "alb_security_group_id" {
  description = "The ID of the security group associated with the ALB"
  value       = aws_security_group.alb_sg.id
}