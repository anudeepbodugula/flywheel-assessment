output "db_instance_endpoint" {
  value       = aws_db_instance.postgresql_instance.endpoint
  description = "The PostgreSQL RDS endpoint"
}

output "postgresql_identifier" {
  value       = aws_db_instance.postgresql_instance.identifier
  description = "The PostgreSQL RDS instance identifier"
}