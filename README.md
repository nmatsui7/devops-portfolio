# Beginner-to-Junior DevOps Operations Tutorial

This repository is an intensive beginner-to-junior DevOps web tutorial and hands-on lab for learning DevOps operations. It uses a small containerized static web app to practice Docker, Docker Compose, GitHub Actions, Kubernetes, Terraform validation, monitoring with Prometheus/Grafana, and optional Ansible host-operations checks.

The repo is structured as a DevOps tutorial. It is intentionally split between working local demo assets and cloud infrastructure scaffolding so learners can see both the runnable path and the infrastructure design direction without confusing this for a production system.

Start with the full tutorial at [docs/tutorial.html](docs/tutorial.html), then use this README as the quick reference for commands, architecture, validation, and scope.

You can open Markdown files such as this README in any text editor or in VS Code.
For complete beginners, they are often easiest to read on the GitHub website in a
browser because GitHub displays headings, lists, links, and command boxes in a
clean format. If you open a `.md` file directly in a text editor or VS Code, you
may see Markdown formatting characters such as backticks.

## Get the Project

If you are new to Git, terminals, or project folders, start here:

[How to Transfer This Repository to Your Computer](How_to_transfer_this_repository_to_your_computer.md)

That guide explains how to download the repository as a ZIP file, place the
files in a folder on your computer, and open `docs/tutorial.html` in a browser.

If you already know Git, you can use this shortcut:

```bash
git clone https://github.com/nmatsui7/devops-tutorial.git
cd devops-tutorial
```

Then open `docs/tutorial.html` in your browser to begin the tutorial.

## Prerequisites

Install these tools before starting the local lab.

### Required

- Git ([Windows installer](https://git-scm.com/install/windows))
- Docker Desktop
- Docker Compose
- kubectl
- Minikube
- Terraform
- Python 3

### Recommended

- A package manager for your OS, such as Homebrew on macOS, apt on Ubuntu/Debian, or Chocolatey/winget on Windows
- yamllint
- actionlint
- shellcheck
- ansible
- ansible-lint
- helm

### Example: macOS Installation

This tutorial is not limited to macOS. Use the official installers or package manager for your operating system. On macOS, you can install command-line tools with Homebrew:

```bash
brew install git kubectl minikube terraform python yamllint actionlint shellcheck ansible ansible-lint helm
```

### Example: Windows Installation

Using winget:

```powershell
winget install --id Git.Git -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id Docker.DockerDesktop -e
winget install --id Kubernetes.kubectl -e
winget install --id Kubernetes.minikube -e
winget install --id Hashicorp.Terraform -e
winget install --id Python.Python.3.12 -e
winget install --id Helm.Helm -e
```

Alternative with Chocolatey:

```powershell
choco install git vscode docker-desktop kubernetes-cli minikube terraform python helm -y
```

Use one Windows package manager, not both.

If you did not install Docker Desktop with Homebrew, winget, or Chocolatey, install it separately from Docker's website. On Windows and macOS, Docker Desktop is the usual beginner path. On Linux, you can use Docker Engine or Docker Desktop. After installation, start Docker before running Docker Compose or Minikube.

On Windows, Ansible and `ansible-lint` are usually easier to run from WSL2 than directly from PowerShell. If those commands are not available in PowerShell, continue with the Docker, Kubernetes, and Terraform parts first, then return to Ansible validation after setting up WSL2.

Verify the tools:

```bash
git --version
docker --version
docker compose version
kubectl version --client
minikube version
terraform version
python3 --version
yamllint --version
actionlint --version
shellcheck --version
ansible --version
ansible-lint --version
helm version
```

The local learning sequence is:

```text
Install tools
-> run Docker Compose local stack
-> start Minikube
-> apply Kubernetes manifests
-> check pods/services/HPA
-> test health endpoint
-> view Prometheus/Grafana
```

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

## Opening Dot Folders In VS Code

Open the whole project folder in Visual Studio Code, not just one file:

```bash
code .
```

In the VS Code Explorer sidebar you can see normal folders like `app/`, `docker/`, and `docs/`. You can also see dot folders such as `.github/`. Dot folders are sometimes hidden by Finder or other file browsers, but VS Code shows them when the project folder is opened.

To inspect GitHub Actions:

1. Open `.github/`.
2. Open `workflows/`.
3. Read `.github/workflows/ci.yml` for CI checks.
4. Read `.github/workflows/cd.yml` for deployment flow.

The `.github` folder is not code that runs on your local computer directly. It tells GitHub Actions what to run on GitHub-hosted runners after you push commits to GitHub.

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
minikube start
kubectl get nodes
kubectl apply -f infrastructure/kubernetes/namespaces.yaml
kubectl apply --dry-run=server -f infrastructure/kubernetes/
```

Kubernetes dry-run commands require a running cluster. Start Minikube first and confirm `kubectl get nodes` works.

## Local Kubernetes Smoke Test

For Minikube, start a local Kubernetes cluster, build the image locally, load it into the cluster, and apply the repo manifests. This is a local validation path; AWS/EKS is not required for the tutorial.

```bash
minikube start
kubectl get nodes

docker build -f docker/Dockerfile -t portfolio/app:local .
minikube image load portfolio/app:local

kubectl apply --dry-run=server -f infrastructure/kubernetes/
kubectl apply -f infrastructure/kubernetes/
kubectl set image deployment/app app=portfolio/app:local -n production
kubectl rollout status deployment/app -n production
kubectl get pods,svc,hpa -n production
kubectl port-forward svc/app 18080:80 -n production
```

In another terminal, check the app endpoints:

```bash
curl -sf http://127.0.0.1:18080/health
curl -sf http://127.0.0.1:18080/ready
curl -sf http://127.0.0.1:18080/metrics
```

When you are done, stop or delete the local cluster:

```bash
minikube stop
minikube delete
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

## Ansible over SSH with Docker Linux Targets

Volume 1 includes a local SSH lab in `ansible/ssh-lab/` where one Ansible
playbook configures three Docker-based Ubuntu targets as nginx web servers. The
lab shows how an inventory group lets you apply one repeatable change to
`worker1`, `worker2`, and `worker3`.

Run it with:

```bash
cd ansible/ssh-lab
docker compose up -d --build
docker compose ps
ANSIBLE_HOST_KEY_CHECKING=False ansible -i inventory.ini workers -m ping
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini docker-ssh-playbook.yml
```

Verify it with:

```bash
docker compose ps

for port in 8081 8082 8083; do
  echo "Checking http://localhost:$port"
  curl -s http://localhost:$port | grep "managed by Ansible"
done
```

This lab is local only. Do not expose the SSH containers to the internet, and do
not reuse the demo password anywhere real.

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
