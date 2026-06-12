# Ansible over SSH with Docker Linux Targets

This Volume 1 lab uses three local Ubuntu containers to simulate three similar
Linux servers. Ansible connects to each target over SSH, installs nginx, and
uses one Jinja2 template to deploy a host-specific web page on every worker.

## Files

```text
ssh-lab/
  Dockerfile
  docker-compose.yml
  inventory.ini
  docker-ssh-playbook.yml
  templates/
    index.html.j2
```

## Run the Lab

```bash
cd ansible/ssh-lab
docker compose up -d --build
docker compose ps
ANSIBLE_HOST_KEY_CHECKING=False ansible -i inventory.ini workers -m ping
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini docker-ssh-playbook.yml
```

## Verify the Web Servers

```bash
docker compose ps

for port in 8081 8082 8083; do
  echo "Checking http://localhost:$port"
  curl -s http://localhost:$port | grep "managed by Ansible"
done
```

You should see successful output for `worker1`, `worker2`, and `worker3`.

## Cleanup

```bash
docker compose down
```

This lab is local only. Do not expose these SSH containers to the internet, and
do not reuse the demo password anywhere real.
