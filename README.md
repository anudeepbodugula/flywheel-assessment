# Flywheel Technical Assessment

This repository contains a full-stack infrastructure and deployment setup for a Java-based health check application using modern DevOps practices.

---

##  What’s Included

-  **Terraform Infrastructure** for AWS (VPC, EKS, RDS, ALB, S3, SGs)
-  **Java Health Check App** (Maven project + Dockerfile)
-  **Kubernetes YAMLs and Helm Chart**
-  **CI/CD pipeline** using GitHub Actions
-  **Remote state backend** (S3 + DynamoDB locking)
-  **Documentation and Architecture Diagrams**

---

##  Folder Structure

- **Helm** - Helm Chart for a Java Application
- **terraform** - Terraform config files
- **java-app** - Java app source code, Dockerfile, Kubernetes manifests
- **NETWORK-DIAGRAM.md** Terraform network diagram and explanation.
- **TERRAFORM.md** Terraform Workflow and config files explanation.
- **JAVA-HELM.md** Java app and Helm chart explanation