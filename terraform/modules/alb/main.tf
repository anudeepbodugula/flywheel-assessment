# Security Group for ALB
resource "aws_security_group" "alb_sg" {
    name = "${var.name_prefix}-alb-sg"
    description = "Allow HTTP and HTTPS traffic to ALB"
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.alb_ingress_cidr_blocks
        description = "Allow HTTP traffic"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = var.alb_ingress_cidr_blocks
        description = "Allow HTTPS traffic"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }

    tags = var.tags
}

# Application Load Balancer
resource "aws_lb" "application_alb" {
    name = "${var.name_prefix}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = var.subnet_ids
    enable_deletion_protection = false

    tags = var.tags
}

# Target Group for ALB
resource "aws_lb_target_group" "alb_target_group" {
    name = "${var.name_prefix}-tg"
    port = var.target_group_port
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        path = var.health_check_path
        interval = 30
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
        matcher = "200"
    }
    tags = var.tags
}

# Listener for ALB
resource "aws_lb_listener" "alb_listener" {
    load_balancer_arn = aws_lb.application_alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb_target_group.arn
    }
}