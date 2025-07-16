

output "eks_sg_id" {
  value       = aws_security_group.eks_sg.id
  description = "EKS Node Security Group ID"
}

output "rds_sg_id" {
  value       = aws_security_group.rds_sg.id
  description = "RDS Security Group ID"
}