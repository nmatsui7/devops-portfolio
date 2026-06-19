# Architecture

This tutorial demonstrates a small static Nginx application with a local runnable path and AWS infrastructure scaffolding. The cloud resources are intentionally documented as scaffold/demo pieces until they are applied in a real AWS account.

```mermaid
flowchart LR
  developer["Developer"] --> github["GitHub Repository"]
  github --> actions["GitHub Actions CI/CD"]
  actions --> ghcr["GHCR Image Registry"]
  actions --> oidc["GitHub OIDC to AWS IAM Role"]
  oidc --> aws["AWS Account"]

  subgraph aws["AWS Scaffold"]
    vpc["VPC + Subnets"]
    eks["EKS Cluster"]
    ecr["ECR Repository"]
    rds["RDS Postgres"]
    state["S3 + DynamoDB Terraform State"]
  end

  terraform["Terraform"] --> vpc
  terraform --> eks
  terraform --> ecr
  terraform --> rds
  terraform --> state

  ghcr --> k8s["Kubernetes Deployment"]
  eks --> k8s
  k8s --> svc["ClusterIP Service"]
  svc --> app["Nginx Static App"]
  app --> health["/health"]
  app --> ready["/ready"]
  app --> metrics["/metrics"]
  metrics --> prometheus["Prometheus"]
  prometheus --> grafana["Grafana"]
```

## Local Demo Path

```text
Docker Compose -> Nginx app -> /health, /ready, /metrics
               -> Prometheus -> Grafana
               -> Postgres placeholder for future app work
```

## AWS Scaffold Path

```text
Terraform -> VPC/private subnets -> EKS/RDS/ECR
GitHub Actions -> GHCR image -> EKS rolling deployment
```

## Boundaries

- The app is a static Nginx demo, not a Node.js or database-backed service.
- RDS and Postgres are included to demonstrate infrastructure design, not active application persistence.
- Ansible configures optional admin-node operational tooling and is not the EKS app deployment path.
