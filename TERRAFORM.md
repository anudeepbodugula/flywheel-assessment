
# Terraform Infrastructure for Flywheel Assessment

This repository defines the modular, secure, and scalable AWS infrastructure setup using Terraform, purpose-built for the Flywheel technical assessment.

---

## Assessment Objective Alignment

| Requirement | How It's Addressed |
|------------|---------------------|
|  Secure AWS network with public/private subnets | VPC module provisions multi-AZ public/private layout |
|  EKS with fault-tolerance | EKS cluster with node groups in private subnets across 2 AZs |
|  PostgreSQL RDS | RDS in private subnet, securely exposed to EKS |
|  Application Load Balancer (ALB) | ALB exposed in public subnet with secure SG and health checks |
|  S3 bucket with VPC Gateway endpoint | Private S3 with encryption, versioning, and endpoint access |
|  Secure connectivity and tagging | Security groups scoped; consistent `common_tags` applied |
|  Modular and reusable Terraform code | All infrastructure broken into cleanly separated modules |

---
## Remote State and Locking

This project uses **S3** for remote backend storage and **DynamoDB** for state locking.

---

## Module Breakdown

### 1. vpc/
- Creates multi-AZ VPC, subnets, IGW, NAT, route tables
- Outputs: subnet IDs, route tables, etc.

### 2. sg/
- SGs for ALB (HTTP/HTTPS), EKS (intra-node), and RDS (5432)
- Scoped access using CIDRs (not hardcoded SG IDs)

### 3. s3/
- Versioned, encrypted S3 bucket
- Private-only access via gateway endpoint

### 4. eks/
- Private subnet-based EKS cluster
- Node groups with autoscaling config

### 5. rds/
- PostgreSQL instance in private subnets
- Subnet group + security ingress from EKS

### 6. alb/
- Application Load Balancer in public subnets
- Health check config + target group for EKS

---

## Security Highlights

-  No hardcoded SGs/CIDRs – uses variables
-  Least-privilege SG rules for each component
-  All backend services in private subnets
-  S3 uses AES256 encryption
---

## Terraform Usage

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
terraform destroy
```

---

## Example Outputs

```
alb_dns_name     = "flywheel-dev-alb-xxxxxx.elb.amazonaws.com"
eks_cluster_name = "flywheel-dev-eks-cluster"
rds_endpoint     = "flywheel-db.xxxx.rds.amazonaws.com"
s3_bucket_name   = "flywheel-dev-app-bucket"
```

---

## Future Improvements

-  Use **AWS SSM Parameter Store** for Terraform inputs (instead of `.tfvars`)
-  Rotate RDS credentials via **Secrets Manager** or **Vault**
-  Integrate CI/CD via GitHub Actions to automate Terraform workflows (plan/apply)
---

