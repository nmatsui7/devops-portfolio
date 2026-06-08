# DevOps Portfolio

Small DevOps portfolio project for a containerized static web app. The repo is intentionally split between working local demo assets and cloud infrastructure scaffolding so recruiters can see both the runnable path and the infrastructure design direction without confusing this for a production system.

## What Works Locally

```bash
docker compose -f docker/docker-compose.yml up --build
```

Local services:

| Service | URL | Notes |
|---|---|---|
| App | http://localhost:8080 | Nginx-served static app |
| Health | http://localhost:8080/health | Returns `healthy` |
| Readiness | http://localhost:8080/ready | Returns `ready` |
| Metrics | http://localhost:8080/metrics | Minimal Prometheus text metrics |
| Prometheus | http://localhost:9090 | Scrapes the local app target |
| Grafana | http://localhost:3000 | Login: `admin` / `admin` |
| Postgres | localhost:5432 | Local service for future app work |

The current app is static HTML behind Nginx. It does not run Node.js, does not connect to Postgres, and does not implement business logic yet.

## Learning Path

Use this repo as a small DevOps lab in this order:

1. Run the local app with Docker Compose and inspect `/health`, `/ready`, and `/metrics`.
2. Read the CI workflow and compare it with the validation evidence in [docs/validation.md](docs/validation.md).
3. Apply the Kubernetes manifests to Minikube or Kind and check the rollout status.
4. Review the Terraform scaffold, run `terraform init -backend=false`, and inspect a plan before applying anything in AWS.
5. Open Prometheus/Grafana locally and confirm how the demo metrics are wired.
6. Review the Ansible admin-node role and its syntax/lint checks without using it to deploy the app.

The full tutorial lives at [docs/tutorial.html](docs/tutorial.html).

## What Is Demo Or Scaffold

- Terraform models AWS VPC, subnets, optional NAT, EKS, RDS, and ECR, but it is a scaffold that needs account-specific review before apply.
- Kubernetes manifests show deployment, service, probes, HPA, ingress, namespace, and disruption-budget patterns for the static app.
- GitHub Actions CI builds and publishes the Docker image to GHCR from `docker/Dockerfile`.
- GitHub Actions CD demonstrates AWS OIDC authentication, EKS kubeconfig setup, rolling deployment, smoke testing, and rollback on rollout failure.
- Ansible configures host-level operational tooling on an optional bastion/admin node. It does not deploy the app or manage Kubernetes workloads.

## Cost Warning

Applying the Terraform can create paid AWS resources, including EKS control plane, EC2 worker nodes, RDS, ECR storage, NAT gateway if enabled, S3 state storage, and DynamoDB state locking.

The `enable_nat_gateway` variable defaults to `false` to avoid NAT gateway cost during review. Private EKS nodes usually need NAT or equivalent private endpoints to pull images and reach required services.

Always run `terraform plan` first and destroy unused environments:

```bash
cd infrastructure/terraform
terraform plan -var="environment=staging"
terraform destroy -var="environment=staging"
```

## Architecture Decisions

- **Static app first:** The current application is deliberately small so the infrastructure and delivery flow stay easy to inspect.
- **GHCR for demo images:** CI publishes to GitHub Container Registry. Terraform also includes ECR to show how an AWS-native registry would be provisioned.
- **OIDC over static AWS keys:** CD uses `aws-actions/configure-aws-credentials` with `AWS_ROLE_TO_ASSUME`, avoiding long-lived AWS access keys in GitHub secrets.
- **Rolling deploy scope:** The current manifests include one deployment, so CD uses Kubernetes rolling updates with rollback traps.
- **Private subnet design:** EKS and RDS are placed in private subnets. NAT is optional and documented because it is useful but costly.
- **Environment separation:** Use separate backend keys, workspaces, or directories per environment before treating this as production infrastructure.
- **Ansible boundary:** Terraform owns infrastructure provisioning, Kubernetes owns app workloads, and Ansible owns optional admin-node operational tooling.

See [docs/architecture.md](docs/architecture.md) for the architecture diagram and boundaries.

## Stack

| Layer | Tool |
|---|---|
| Cloud scaffold | AWS VPC, EKS, RDS, ECR |
| IaC | Terraform |
| Containers | Docker, Docker Compose |
| Orchestration | Kubernetes |
| CI/CD | GitHub Actions |
| Monitoring demo | Prometheus, Grafana |
| Host ops | Ansible |
| App | Nginx static site |

## Quick Start

```bash
# Start the local stack
docker compose -f docker/docker-compose.yml up --build

# Validate Terraform syntax
cd infrastructure/terraform
terraform init -backend=false
terraform validate
terraform plan -var="environment=staging"

# Inspect Kubernetes manifests
kubectl apply -f infrastructure/kubernetes/namespaces.yaml
kubectl apply --dry-run=server -f infrastructure/kubernetes/
```

## Local Kubernetes Smoke Test

For Minikube or Kind, build the image locally, load it into the cluster, and override the demo deployment image:

```bash
docker build -f docker/Dockerfile -t portfolio/app:kind .
minikube image load portfolio/app:kind
kubectl apply -f infrastructure/kubernetes/
kubectl set image deployment/app app=portfolio/app:kind -n production
kubectl rollout status deployment/app -n production
kubectl port-forward svc/app 18080:80 -n production
```

Then check:

```bash
curl -sf http://127.0.0.1:18080/health
curl -sf http://127.0.0.1:18080/ready
curl -sf http://127.0.0.1:18080/metrics
```

## Terraform State

The Terraform backend expects an existing S3 bucket and DynamoDB lock table:

```bash
terraform init \
  -backend-config="bucket=portfolio-terraform-state" \
  -backend-config="key=staging/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="encrypt=true" \
  -backend-config="dynamodb_table=terraform-state-lock"
```

Bootstrap those resources separately or change the backend configuration before running `terraform init`. For real environment separation, use different state keys such as `staging/terraform.tfstate` and `production/terraform.tfstate`.

## GitHub Actions Setup

Required repository secrets:

| Secret | Purpose |
|---|---|
| `AWS_ROLE_TO_ASSUME` | IAM role ARN trusted by GitHub OIDC |

Required repository variables:

| Variable | Purpose |
|---|---|
| `EKS_CLUSTER_NAME` | Target EKS cluster for staging and production namespace deploys |
| `PRODUCTION_URL` | Public production base URL used by the smoke test |
| `AWS_REGION` | Optional; defaults to `us-east-1` |
| `STAGING_NAMESPACE` | Optional; defaults to `staging` |
| `PRODUCTION_NAMESPACE` | Optional; defaults to `production` |

The CD workflow also expects:

- An existing EKS cluster matching `EKS_CLUSTER_NAME`.
- Namespaces and deployment already present in the target cluster.
- `PRODUCTION_URL` set to a real domain before production use.

## Ansible Scope

Ansible is limited to optional host-level operations for a bastion/admin node:

- common operations packages
- `kubectl`, `helm`, and `aws` availability checks
- backup helper script deployment
- optional `node_exporter` setup
- basic SSH hardening

See [ansible/README.md](ansible/README.md) for inventory, role boundaries, and validation commands. App deployment remains owned by Kubernetes manifests and GitHub Actions.

## Screenshots And Evidence

Proof artifacts are tracked in [docs/screenshots](docs/screenshots/README.md):

- GitHub Actions CI pipeline pass.
- Local Docker Compose stack with app, Postgres, Prometheus, and Grafana reachable.
- App `/health`, `/ready`, and `/metrics` output.
- Prometheus scraping the app metrics endpoint.
- Minikube Kubernetes pod, service, HPA, PDB, and ingress status.

Command-level validation evidence is tracked in [docs/validation.md](docs/validation.md). Terraform remains documented as validation/scaffold evidence until a real AWS plan is captured with safe, redacted values.

## Project Structure

```text
.github/workflows/     CI/CD workflows
app/                   Static Nginx app and config
docker/                Dockerfile and Compose stack
infrastructure/
  kubernetes/          Deployment, service, HPA, ingress, namespaces
  terraform/           AWS infrastructure scaffold
monitoring/            Prometheus config, alerts, dashboard JSON
ansible/               Optional admin-node operations playbook
scripts/               Utility scripts
```
