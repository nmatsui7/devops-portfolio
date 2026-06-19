# Ansible Role

Ansible has a deliberately narrow role in this tutorial:

```text
Terraform   -> provisions cloud infrastructure
Kubernetes  -> runs and manages app workloads
Ansible     -> configures host-level operational tooling on an optional admin node
```

The playbook does not deploy the application and does not manage Kubernetes workloads. GitHub Actions and Kubernetes manifests own deployment.

## What It Configures

The `admin_ops` role is intended for an optional EC2 bastion/admin node:

- common operations packages
- checks for `kubectl`, `helm`, and `aws`
- backup script deployment
- optional `node_exporter` setup
- basic SSH hardening

All inventory values are examples. No secrets, private keys, or credentials are committed.

## Example Usage

```bash
ansible-playbook -i ansible/inventory.example.ini ansible/playbook.yml --syntax-check
ansible-lint ansible/playbook.yml
```

To apply it to a real host, copy `inventory.example.ini`, replace the placeholder host, and provide credentials through your normal SSH agent or secure inventory process.

## Boundaries

- Do not use this playbook to deploy the app.
- Do not put AWS keys, SSH private keys, database passwords, or kubeconfigs in this repo.
- The backup script is deployed as an operational helper; it still requires runtime environment variables and AWS permissions on the target host.
