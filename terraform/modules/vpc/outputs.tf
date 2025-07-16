output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "Private subnet IDs"
}

output "nat_gateway_ids" {
  value       = aws_nat_gateway.main[*].id
  description = "NAT Gateway IDs"
}


output "public_subnet_cidrs" {
  description = "CIDRs of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_route_table_ids" {
  description = "Route table IDs for private subnets"
  value       = aws_route_table.private[*].id
}
output "private_subnet_cidrs" {
  description = "CIDRs of private subnets"
  value       = aws_subnet.private[*].cidr_block
}
