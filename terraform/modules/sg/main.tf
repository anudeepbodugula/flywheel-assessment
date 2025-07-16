# ALB Security Group
# resource "aws_security_group" "alb_sg" {
#  name        = "${var.name_prefix}-alb-sg"
#  description = "Allow HTTP and HTTPS traffic to ALB"
#  vpc_id      = var.vpc_id

#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = var.alb_ingress_cidr_blocks
#    description = "Allow HTTP traffic from internet"
#  }

#  ingress {
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = var.alb_ingress_cidr_blocks
#    description = "Allow HTTPS traffic from internet"
#  }

#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#    description = "Allow all outbound traffic"
#  }

#  tags = var.tags
#}

# EKS Node Security Group
resource "aws_security_group" "eks_sg" {
  name        = "${var.name_prefix}-eks-sg"
  description = "Allow traffic within EKS node group and from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow intra-node communication"
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidr_blocks
    description = "Allow HTTP traffic from ALB to EKS nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = var.tags
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Allow PostgreSQL traffic from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.eks_node_subnet_cidrs
    description = "Allow traffic from EKS nodes to RDS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = var.tags
}