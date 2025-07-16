# Java Health Check App – Deployment Guide

This project contains:
- A simple **Java-based health check application**
- Kubernetes manifests (YAML)
- Helm chart with best practices for deployment, resource limits, and autoscaling

---

## Assessment Requirement Addressed

> **Requirement**: _Provide a Helm chart for a Java application, and specify scaling and resources._

Helm chart is provided with:
- Resource requests and limits  
- Horizontal Pod Autoscaler (HPA) support  
- Image pull secrets  
- Secure environment variable injection via Kubernetes Secrets  
- AWS ALB ingress integration

---

## 1. Java Application Overview

A Maven-based Java application exposing:
- `/health` → Returns HTTP 200
- `/db-health` → Verifies RDS DB connectivity

> Built and tested with:
```bash
mvn clean install
```

---

## 2. Docker Image

Dockerfile uses a multi-stage build:
- Stage 1: Compile Java app with Maven
- Stage 2: Lightweight runtime using `eclipse-temurin`

> Built and pushed to DockerHub:
```bash
docker build -t anudeepbm1993/flywheel-java-app:v1.0 .
docker push anudeepbm1993/flywheel-java-app:v1.0
```

---

## 4. Helm Chart (`./java-app/Helm`)

The Helm chart provides a parameterized deployment for the Java app.

### Includes:
- `Chart.yaml` – Helm metadata
- `values.yaml` – Parameter config (image, env, resources, probes, HPA)
- `templates/` – Deployment, Service, Ingress, Secret, HPA

> To install with Helm:
```bash
helm install java-app ./java-health-check-app
```

> To template YAML locally:
```bash
helm template java-app ./java-health-check-app > output.yaml
```

---

## 5. Scaling & Resources

### Resource Requests & Limits:
```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

### Horizontal Pod Autoscaler:
- Min replicas: 2  
- Max replicas: 5  
- CPU Utilization Target: 70%

---

##  6. Secrets & Security

- Environment variables (`DB_HOST`, `DB_PORT`, etc.) are injected securely via Kubernetes Secret.
- Container runs as non-root user `1000` with `allowPrivilegeEscalation: false`.

---

## 7. Ingress

- Configured to use AWS ALB via annotations
- Path-based routing to `java-health-check-app` Service

---
## 3. Kubernetes Manifests

Manually written manifests (`./java-app/Kubernetes/`):
- `deployment.yaml` – Java app deployment with probes, security context
- `service.yaml` – ClusterIP service
- `secret.yaml` – DB credentials
- `ingress.yaml` – ALB ingress setup
- `hpa.yaml` – Horizontal Pod Autoscaler

---



## Summary

| Feature               | Implemented |
|-----------------------|-------------|
| Helm chart            |  Yes       |
| Resource constraints  |  Yes       |
| Horizontal scaling    |  Yes (HPA) |
| Secure secrets        |  Yes       |
| Readiness/Liveness    |  Yes       |
| AWS ALB ingress       |  Yes       |


## Future Improvements

Here are some enhancements that can be implemented in future iterations of the application and Helm charts:

1. **Use AWS Secrets Manager or SSM Parameter Store**  
   - Replace hardcoded secrets or Kubernetes Secrets with managed secret storage like [AWS Secrets Manager] or [SSM Parameter Store].  
   - Enables secure secret storage, IAM-based access control, and automatic rotation.

2. **Add CI/CD Pipelines**  
   - Automate build, test, and deployment using GitHub Actions.  
   - Use GitOps tools like ArgoCD or Flux to manage Helm chart deployments.

3. **Implement Observability**  
   - Integrate Prometheus and Grafana for metrics.  
   - Use CloudWatch, ELK, or Datadog for logging and alerting.



