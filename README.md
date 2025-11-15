# Website Portfolio - Multi-cloud Infrastructure Lab - Zero Costs

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
| **Containerization** | Docker, Docker Compose | Packaging the application and its dependencies into containers to ensure consistency between environments. |
| **Orchestration** | Kubernetes (OKE) | Deployment in an orchestrated container environment for high availability and scalability. |
| **CI/CD** | GitLab CI/CD | Complete automation of the build, test, and deploy cycle, with modular and dynamic pipelines. |
| **Observability** | Prometheus, Grafana, cAdvisor, OpenTelemetry | Collection of metrics, logs, and traces for a holistic view of the system's health and performance. |
| **Security** | Fail2Ban, Cloudflare | Active protection against brute-force and injection attacks (Fail2Ban) and DNS/WAF management (Cloudflare). |

---

## Architecture Highlights

This project implements solutions for common challenges in software engineering and operations.

#### 1. **Infrastructure as Code (IaC) with Terraform Cloud**
All infrastructure on Oracle Cloud (OCI) is managed via Terraform. The use of **Terraform Cloud** for managing the *state file* and executing *runs* ensures a collaborative, secure, and auditable workflow, decoupling the execution from the developer's local machine.

#### 2. **Automated CI/CD Pipeline**
The pipeline in GitLab CI/CD orchestrates the entire deployment process. For VM deployment, the flow is:
- **Provisioning**: Triggers a *run* in Terraform Cloud to create or update the instance.
- **Validation**: Waits for the VM's *startup script* to finish, ensuring that dependencies are ready.
- **Deploy**: Connects via SSH, clones the repository, and brings up the service stack with `Docker Compose`.
- **DNS**: Dynamically updates the DNS records in Cloudflare to point to the new infrastructure.

#### 3. **Integrated Observability**
The monitoring stack was designed to provide full visibility:
- **Infrastructure and Application Metrics**: **Prometheus** collects metrics from `cAdvisor` (container performance), `nginx-vts-exporter` (throughput, latencies in Nginx), and the Flask application itself.
- **Interactive Dashboards**: **Grafana** consumes data from Prometheus to display real-time dashboards, allowing for trend analysis and anomaly detection.
- **Distributed Tracing**: **OpenTelemetry** is integrated into the Flask application to allow request tracing across services.

#### 4. **Active Security**
**Fail2Ban** is configured to monitor Nginx logs in real time. It automatically bans IP addresses that exhibit malicious behavior (e.g., vulnerability scanning, injection attempts), adding an essential security layer directly at the infrastructure *edge*.

---

## Deployment Models

The repository supports two deployment models, demonstrating flexibility for different environments.

- **Model 1: Automated VM (Main Deployment)**
  - **Description**: A CI/CD pipeline provisions a VM on OCI and deploys the complete service stack using Docker Compose.
  - **Ideal for**: Scenarios where the simplicity of a single VM is preferable, but with full automation.

- **Model 2: Orchestration with Kubernetes**
  - **Description**: The manifests in the `/kubernetes` folder define the resources to deploy the application in a Kubernetes cluster (like OKE).
  - **Ideal for**: Environments that require high availability, auto-scaling, and advanced container management.

---

## Repository Structure

```
/
├── docker-compose/     # Local orchestration of services (app, nginx, monitoring)
├── iac/                # Infrastructure as Code (Terraform, Packer)
├── kubernetes/         # Manifests for deployment in Kubernetes
├── pipelines/          # GitLab CI/CD pipeline definitions
├── usefull-scripts/    # Utility scripts for automation and troubleshooting
└── docker-compose/webport/ # Flask application source code and Dockerfile
```

---

## Running the Environment Locally

### Prerequisites
- Docker & Docker Compose
- Git

### Steps
1.  **Clone the repository:**
    ```bash
    git clone https://gitlab.com/yohrannes/website-portifolio.git
    cd website-portifolio
    ```

2.  **Bring up the containers:**
    ```bash
    docker compose up -d --build
    ```
    This command will build the images and start all services in the background.

3.  **Access the services:**
    - **Website**: `http://localhost`
    - **Grafana**: `http://localhost:3000`
    - **Nginx Metrics**: `http://localhost/status`

---

## Contact

- **LinkedIn**: [Yohrannes Santos Bigoli](https://www.linkedin.com/in/yohrannes)
- **GitHub**: [@yohrannes](https://github.com/yohrannes)
- **GitLab**: [@yohrannes](https://gitlab.com/yohrannes)