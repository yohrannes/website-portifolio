# docker-compose/ — Local Override Scaffold

This directory serves as a **local-files scaffold** for users who prefer to manage
the application stack without the external Git submodule.

## Default provisioning (recommended)

The canonical source of truth for all Docker Compose configurations lives in the
[`yohrannes-com`](../yohrannes-com/docker-compose/) submodule, sourced from:

```
https://github.com/yohrannes/yohrannes.com.git
```

All CI/CD pipelines consume `yohrannes-com/docker-compose/` by default.

## Local override workflow

If you need to run the stack with local modifications (without touching the submodule):

1. Copy the submodule content into this directory:
   ```bash
   cp -r yohrannes-com/docker-compose/. docker-compose/
   ```

2. Make your local changes inside `docker-compose/`.

3. Update the pipeline variable or `docker compose` command to point here instead:
   ```bash
   docker compose -f docker-compose/docker-compose.yml up -d
   ```

> **Note:** Files placed here are tracked by this repository and will not affect
> the external `yohrannes-com` submodule.

## Directory structure

```
docker-compose/
├── fail2ban/       # Fail2Ban container config and filters
├── nginx/          # Nginx reverse proxy config and Dockerfiles
├── observability/  # Prometheus, Grafana provisioning
├── tf-multi-arch/  # Multi-arch Terraform helper image
└── webport/        # Flask application source, Dockerfile, static assets
```
