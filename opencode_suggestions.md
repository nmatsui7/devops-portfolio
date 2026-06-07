

ok docker desktop is running.
Let's start with Docker Compose — it's the quickest win and doesn't need Minikube.

From the project root folder, run:

docker compose -f docker/docker-compose.yml up -d
This will build the app image and pull PostgreSQL, Prometheus, and Grafana. After it finishes, check:

docker ps
You should see 4 containers. Then open http://localhost:8080 in your browser — the portfolio dashboard should be live. Prometheus is at http://localhost:9090 and Grafana at http://localhost:3000 (admin/admin).