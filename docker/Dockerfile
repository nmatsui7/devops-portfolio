FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="devops-portfolio"
LABEL org.opencontainers.image.description="Static Nginx DevOps portfolio demo"
LABEL org.opencontainers.image.source="https://github.com/nmatsui7/devops-portfolio"

COPY app/index.html /usr/share/nginx/html/index.html
COPY app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:8080/health || exit 1
