## DB Subner Group for Private Subnets
resource "aws_db_subnet_group" "postgresql_subnet_group" {
    name = "${var.name}-postgresql-subnet-group"
    subnet_ids = var.subnet_ids

    tags = {
        Name = "${var.name}-postgresql-subnet-group"
        }
}

# Security Group for RDS
resource "aws_security_group" "postgresql_sg" {
    name = "${var.name}-postgresql-sg"
    description = "Security group for PostgreSQL RDS instance"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow inbound PostgresSQL traffic"
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = var.allowed_cidr_blocks
    }

    egress {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgresql_instance" {
    identifier = var.name
    engine = "postgres"
    engine_version = var.engine_version
    instance_class = var.instance_class
    allocated_storage = var.allocated_storage
    max_allocated_storage = var.max_allocated_storage
    storage_encrypted = true
    multi_az = true
    username = var.username
    password = var.password
    db_subnet_group_name = aws_db_subnet_group.postgresql_subnet_group.name
    vpc_security_group_ids = [aws_security_group.postgresql_sg.id]
    skip_final_snapshot = true
    publicly_accessible = false

    tags = var.tags
}