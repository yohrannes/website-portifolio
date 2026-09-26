# Website Portfolio - Multi-cloud Infrastructure Lab - Zero Costs

[![Pipeline Status](https://gitlab.com/yohrannes/website-portifolio/badges/main/pipeline.svg)](https://gitlab.com/yohrannes/website-portifolio/-/commits/main)
![Terraform Cloud](https://img.shields.io/badge/Terraform%20Cloud-managed-blueviolet?logo=terraform)

This repository is a functional, production-level blueprint for building, deploying, and observing a modern web application ecosystem. The project was designed to demonstrate software engineering and DevOps practices in a real-world scenario, with a focus on automation, resilience, and security.

## Architecture and Philosophy

The goal of this project goes beyond a simple portfolio. It serves as a practical demonstration of a complete software development lifecycle, from infrastructure provisioning to continuous monitoring in production.

The philosophy is simple: **automation in everything**. The infrastructure is declarative (IaC), deployments are automated (CI/CD), and observability is natively integrated to enable proactive failure detection and performance analysis.

---

## Technology Stack

The technology selection was made to reflect a modern production environment, prioritizing open-source, mature, and widely adopted tools in the industry.

| Category | Tool | Purpose |
| :--- | :--- | :--- |
| **Application** | Flask (Python), Gunicorn | Lightweight, high-performance, and scalable backend to serve the API and web pages. |
| **Reverse Proxy & Load Balancer** | Nginx | Entry point for all traffic, with SSL termination, caching, and high-performance metrics. |
| **Infrastructure as Code** | Terraform, Packer | Declarative provisioning and management of the infrastructure on OCI. Packer is used to create immutable machine images. |
| **Containerization** | Docker, Docker Compose | Packaging the application and its dependencies into containers. **Compose stack sourced from `yohrannes.com`**. |
| **Orchestration** | Kubernetes (OKE) | Deployment in an orchestrated container environment for high availability and scalability. **Manifests sourced from `yohrannes.com`**. |
| **CI/CD** | GitLab CI/CD | Complete automation of the build, test, and deploy cycle, with modular and dynamic pipelines. |
| **Observability** | Prometheus, Grafana, cAdvisor, OpenTelemetry | Collection of metrics, logs, and traces for a holistic view of the system's health and performance. |

---

## Architecture Highlights

This project implements solutions for common challenges in software engineering and operations.

#### 1. **Infrastructure as Code (IaC) with Terraform Cloud**
All infrastructure on Oracle Cloud (OCI) is managed via Terraform. The use of **Terraform Cloud** for managing the *state file* and executing *runs* ensures a collaborative, secure, and auditable workflow, decoupling the execution from the developer's local machine.

#### 2. **Automated CI/CD Pipeline**
The pipeline in GitLab CI/CD orchestrates the entire deployment process. For VM deployment (Model 1), the flow is:
- **Provisioning**: Triggers a *run* in Terraform Cloud to create or update the instance.
- **Validation**: Waits for the VM's *startup script* to finish, ensuring that dependencies are ready.
- **Deploy**: Connects via SSH, **pulls the Docker Compose stack from `yohrannes.com`**, and brings up the service stack with `Docker Compose`.
- **DNS**: Dynamically updates the DNS records in Cloudflare to point to the new infrastructure.

For Kubernetes deployment (Model 2), the pipeline applies the manifests sourced from `yohrannes.com/kubernetes/app-manifest/` via `kubectl`/`kustomize` against the target OKE cluster.

#### 3. **Integrated Observability** (Docker Compose Stack)
The monitoring stack is defined in the **external `yohrannes.com/docker-compose/observability`** and provides full visibility:
- **Infrastructure and Application Metrics**: **Prometheus** collects metrics from `cAdvisor` (container performance), `nginx-vts-exporter` (throughput, latencies in Nginx), and the Flask application itself.
- **Interactive Dashboards**: **Grafana** consumes data from Prometheus to display real-time dashboards, allowing for trend analysis and anomaly detection.
- **Distributed Tracing**: **OpenTelemetry** is integrated into the Flask application to allow request tracing across services.

#### 4. **Active Security** (Docker Compose Stack)
**Fail2Ban** (defined in `yohrannes.com/docker-compose/fail2ban`) monitors Nginx logs in real time. It automatically bans IP addresses that exhibit malicious behavior (e.g., vulnerability scanning, injection attempts), adding an essential security layer directly at the infrastructure *edge*.

#### 5. **Multi-Architecture Docker Image Registry**
The pipeline in `pipelines/gitlab-ci-cd/docker-images/docker-registry.yml` publishes the application and Nginx images to a central Docker registry as **multi-architecture images (amd64 + arm64)**, ensuring the stack runs natively on any infrastructure — from standard x86 servers to ARM machines such as the OCI Ampere A1 instances:
- **Parallel Cross-Platform Builds**: The `deploy-dk-hub-amd` job uses **Docker Buildx** with **QEMU** user-space emulation to build and push the `linux/amd64` images, while `deploy-dk-hub-arm` builds natively on an ARM-based runner and pushes the `linux/arm64` images — both running in parallel.
- **Unified Multi-Arch Manifest**: The `deploy-dk-hub` job merges both architecture-specific images into a single multi-architecture manifest via `docker buildx imagetools create`, published under a SemVer tag and `latest`. At deploy time, Docker automatically pulls the correct architecture for the target host.
- **Automated Semantic Versioning**: A pre-deploy job (`get-image-tag`) computes the next SemVer tag (patch) from the previous image version and stores it as GitLab CI/CD variables, making every registry publish traceable and reproducible.

---

## Deployment Models

The repository supports two deployment models, demonstrating flexibility for different environments. **Both models consume their runtime configurations from the external project [`yohrannes/yohrannes.com`](https://github.com/yohrannes/yohrannes.com.git)**, which maintains the Docker Compose stack and Kubernetes manifests as versioned, reusable modules.

- **Model 1: Automated VM (Main Deployment)**
  - **Description**: A CI/CD pipeline provisions a VM on OCI and deploys the complete service stack using **Docker Compose** (sourced from `yohrannes.com/docker-compose` at build/deploy time).
  - **Ideal for**: Scenarios where the simplicity of a single VM is preferable, but with full automation.

- **Model 2: Orchestration with Kubernetes**
  - **Description**: The Kubernetes manifests (sourced from `yohrannes.com/kubernetes/app-manifest/`) define the resources to deploy the application in a Kubernetes cluster (like OKE), including `Deployment` (3 replicas, resource quotas), `Service`, and `HTTPRoute` (Gateway API).
  - **Ideal for**: Environments that require high availability, auto-scaling, and advanced container management.

---

## Repository Structure

```
/
├── iac/                # Infrastructure as Code (Terraform, Packer)
├── pipelines/          # GitLab CI/CD pipeline definitions
├── usefull-scripts/    # Utility scripts for automation and troubleshooting
└── docs/               # Additional documentation
```

> **Note**: The `docker-compose/` and `kubernetes/` runtime configurations are **not stored in this repository**. They are pulled from [`yohrannes/yohrannes.com`](https://github.com/yohrannes/yohrannes.com.git) during CI/CD execution. This modularization ensures a single source of truth for the application stack across multiple consumers.

---

## Running the Environment

The runtime stack (Docker Compose or Kubernetes manifests) is **not included in this repository**. To run locally or deploy, you must fetch the configurations from the source project:

```bash
# Clone the external runtime configurations
git clone https://github.com/yohrannes/yohrannes.com.git
cd yohrannes.com
```

### Model 1: Docker Compose (Local / VM)

```bash
cd docker-compose
docker compose up -d --build
# Access: http://localhost (app), http://localhost:3000 (Grafana), http://localhost/status (Nginx VTS)
```

### Model 2: Kubernetes (OKE / Local Kind)

```bash
cd kubernetes/app-manifest
kubectl apply -k .
# Or for local development with Kind:
kind create cluster && kubectl apply -k .
```

### Prerequisites

| Tool | Purpose |
| :--- | :--- |
| Docker & Docker Compose | Container runtime and local orchestration (Model 1) |
| kubectl / kustomize | Kubernetes manifest application (Model 2) |
| Terraform | Infrastructure provisioning (OCI) |
| GitLab CI/CD | Pipeline execution (production) |

### Authentication Requirements

- **OCI CLI** configured with tenancy credentials for Terraform/instance provisioning
- **GitLab CI/CD Variables**: `DOCKER_REG_PASSWORD`, `GITLAB_TOKEN`, `TF_API_TOKEN`, `CLOUDFLARE_API_TOKEN`
- **kubeconfig** for target Kubernetes cluster (OKE or local)


---

## Contact

- **LinkedIn**: [Yohrannes Santos Bigoli](https://www.linkedin.com/in/yohrannes)
- **GitHub**: [@yohrannes](https://github.com/yohrannes)
- **GitLab**: [@yohrannes](https://gitlab.com/yohrannes)