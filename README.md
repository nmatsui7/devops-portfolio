# DevOps Portfolio

End-to-end infrastructure and deployment pipeline for a containerized web application.

## Architecture

```
                    ┌──────────────┐
                    │   GitHub     │
                    │  Actions     │
                    └──────┬───────┘
                           │ CI/CD
                    ┌──────▼───────┐
                    │  Container   │
                    │  Registry    │
                    │  (ECR/GHCR)  │
                    └──────┬───────┘
                           │ deploy
                    ┌──────▼───────┐
                    │  Kubernetes  │
                    │  (EKS)       │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
        ┌─────▼────┐ ┌────▼────┐ ┌────▼────┐
        │   App    │ │  RDS   │ │Monitoring│
        │ Service  │ │Postgres│ │Prom/Graf │
        └──────────┘ └─────────┘ └──────────┘
```

## Stack

| Layer | Tool |
|---|---|
| Cloud | AWS (EKS, RDS, VPC, ECR, S3) |
| IaC | Terraform |
| Containers | Docker, docker-compose |
| Orchestration | Kubernetes |
| CI/CD | GitHub Actions |
| Config Mgmt | Ansible |
| Monitoring | Prometheus, Grafana |
| App | Node.js, Nginx |

## Quick Start

```bash
# Start locally
docker compose -f docker/docker-compose.yml up -d

# Provision infrastructure
cd infrastructure/terraform
terraform init
terraform plan -var="environment=staging"
terraform apply -var="environment=staging"

# Deploy to Kubernetes
kubectl apply -f infrastructure/kubernetes/
```

## Project Structure

```
.github/workflows/     CI/CD pipelines
infrastructure/
  terraform/           AWS infrastructure as code
  kubernetes/          K8s manifests (deploy, service, HPA, ingress)
docker/                Dockerfile & compose files
monitoring/            Prometheus rules & Grafana config
ansible/               Server provisioning playbooks
scripts/               Utility scripts (backup, etc.)
app/                   Sample application
```

## CI/CD Pipeline

- **CI**: lint, test (matrix: node 18/20/22), build, push Docker image
- **CD**: on tag push → deploy to staging → canary (10%) → smoke test → full rollout
