# Validation Evidence

Last checked: 2026-06-07 21:24:31 EDT

This file records local validation evidence for the tutorial scaffold. It is not a production certification; it is a concise proof trail that the committed local demo and infrastructure examples parse, build, and run in the tested environment.

## GitHub Remote

Remote `main` can be checked with:

```bash
git ls-remote origin refs/heads/main
```

## File Formatting

The previously reported "collapsed file" issue is not present in this checkout. Representative line counts:

```text
 108 .github/workflows/ci.yml
 104 .github/workflows/cd.yml
   9 docker/Dockerfile
  61 docker/docker-compose.yml
 242 infrastructure/terraform/main.tf
 106 infrastructure/kubernetes/deployment.yaml
 198 README.md
```

Screenshots and run logs from the local stack, Minikube, and GitHub Actions are tracked in [docs/screenshots](screenshots/README.md).

## YAML And JSON Parsing

Dedicated YAML and workflow linting passed:

```bash
yamllint .github/workflows infrastructure/kubernetes docker/docker-compose.yml monitoring ansible
actionlint .github/workflows/ci.yml .github/workflows/cd.yml
```

Parsed successfully:

```text
ok .github/workflows/ci.yml
ok .github/workflows/cd.yml
ok docker/docker-compose.yml
ok ansible/playbook.yml
ok monitoring/prometheus.yml
ok monitoring/alerts.yml
ok infrastructure/kubernetes/namespaces.yaml
ok infrastructure/kubernetes/deployment.yaml
ok infrastructure/kubernetes/ingress.yaml
ok monitoring/grafana-dashboard.json
```

## Ansible

Ansible syntax and lint checks passed:

```bash
ansible-playbook -i ansible/inventory.example.ini ansible/playbook.yml --syntax-check
ansible-lint ansible/playbook.yml
```

`ansible-lint` passed with the production profile:

```text
Passed: 0 failure(s), 0 warning(s)
```

## CI Coverage

GitHub Actions CI now validates more than the static HTML page:

```text
yamllint
actionlint
ShellCheck
ansible-playbook --syntax-check
ansible-lint
HTML parse check
docker compose config
docker build
terraform fmt -recursive -check
terraform init -backend=false
terraform validate
kubectl apply --dry-run=server
```

## Docker

Docker Compose rendered successfully:

```bash
docker compose -f docker/docker-compose.yml config
```

Docker image build succeeded:

```bash
docker build -f docker/Dockerfile -t portfolio/app:validation .
```

## Terraform

Terraform formatting and validation passed:

```bash
terraform fmt -recursive -check infrastructure/terraform
terraform validate
```

Validation output:

```text
Success! The configuration is valid.
```

CI also runs:

```bash
terraform init -backend=false
```

## Local Kubernetes

Kubernetes manifest dry-run command:

```bash
kubectl apply -f infrastructure/kubernetes/namespaces.yaml
kubectl apply --dry-run=server -f infrastructure/kubernetes/
```

Output:

```text
deployment.apps/app configured (server dry run)
service/app unchanged (server dry run)
horizontalpodautoscaler.autoscaling/app unchanged (server dry run)
ingress.networking.k8s.io/app unchanged (server dry run)
poddisruptionbudget.policy/app configured (server dry run)
namespace/production unchanged (server dry run)
namespace/staging unchanged (server dry run)
```

Validated and smoke-tested on Minikube with a locally loaded image.

Rollout status:

```text
deployment "app" successfully rolled out
```

Resource status:

```text
pod/app-7954664c5-fplsf   1/1 Running
pod/app-7954664c5-gkkqp   1/1 Running
pod/app-7954664c5-q94lg   1/1 Running
service/app               ClusterIP 80/TCP
horizontalpodautoscaler.autoscaling/app cpu: <unknown>/70%, memory: <unknown>/80%
poddisruptionbudget.policy/app          allowed disruptions: 1
ingress.networking.k8s.io/app           app.your-domain.example
```

HPA metrics are `<unknown>` because the Minikube `metrics-server` addon was disabled during validation.

Smoke tests through `kubectl port-forward svc/app 18080:80 -n production` passed:

```text
/health  -> healthy
/ready   -> ready
/metrics -> portfolio_app_ready 1
```
