# Output the EKS cluster name
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

# Output the EKS cluster endpoint
output "eks_cluster_endpoint" {
  description = "API server endpoint of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

# Output the cluster certificate
output "eks_cluster_certificate_authority" {
  description = "Certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

# Output the node group names
output "node_group_names" {
  description = "List of node group names"
  value       = [for ng in aws_eks_node_group.main : ng.node_group_name]
}

# Output the cluster ARN
output "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}