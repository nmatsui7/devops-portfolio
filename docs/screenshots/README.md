# Screenshots And Run Evidence

These captures show the tutorial demo running locally and the GitHub Actions pipeline passing. They are proof-of-work artifacts for learners; they are not evidence of a live AWS production deployment.

## Captured Evidence

| Evidence | File |
| --- | --- |
| GitHub Actions workflow list, redacted for tutorial use | [github-actions-workflows-redacted.png](github-actions-workflows-redacted.png) |
| GitHub Actions CI pipeline pass | [github-actions-ci-pass.png](github-actions-ci-pass.png) |
| Local Nginx app served by Docker Compose | [local-app.png](local-app.png) |
| Prometheus scraping the local app metrics endpoint | [prometheus-targets.png](prometheus-targets.png) |
| Grafana service reachable from the local Compose stack | [grafana-local.png](grafana-local.png) |
| Docker Compose services plus `/health`, `/ready`, `/metrics` output | [local-stack.txt](local-stack.txt) |
| Minikube Kubernetes pods, service, HPA, PDB, and ingress status | [kubernetes-status.txt](kubernetes-status.txt) |
| Recent GitHub Actions run list and latest CI metadata | [github-actions-ci.txt](github-actions-ci.txt) |

## Notes

- The local app screenshot was captured from `http://127.0.0.1:8080/`.
- Prometheus targets were captured from `http://127.0.0.1:9090/targets`.
- The plain-text `/metrics` endpoint is recorded in [local-stack.txt](local-stack.txt).
- Kubernetes evidence was captured from a local Minikube cluster, not from live AWS EKS.
- Terraform remains a scaffold until AWS backend and environment values are supplied.
