# GitLab CI/CD Pipeline Environment Variables Specification

**File:** `docs/pipeline-environment-variables.md`  
**Scope:** Complete technical reference and operational guide for all GitLab CI/CD environment variables required to run the automated infrastructure, testing, and deployment pipelines.

---

## 1. Overview & Architecture Context

The `website-portifolio` deployment pipeline automates multi-cloud infrastructure provisioning, container image builds, Kubernetes deployments, and automated DNS failover. To operate securely and reliably, the pipeline requires specific environment variables configured at the repository level.

### Variable Classification
Environment variables in this project are organized into two distinct layers:
1. **Repository-Level CI/CD Variables:** Sensitive credentials, API tokens, dynamic cluster endpoints, and runtime secrets configured via GitLab settings or the `glab` CLI.
2. **Pipeline-Level Variables:** Static defaults defined directly in [.gitlab-ci.yml](file:///home/yohrannes/repos-git/website-portifolio/.gitlab-ci.yml) (e.g., timezones, Terraform Cloud organization name, retry timeouts), requiring no manual repository setup.

```mermaid
flowchart TD
    subgraph RepoVars["GitLab Repository CI/CD Variables (Secrets & State)"]
        OCI["Oracle Cloud (OCI) & HCP Tokens"]
        CF["Cloudflare DNS & Failover"]
        GL["GitLab Runner & Admin Tokens"]
        SSH["SSH Keys & Host IPs"]
        DK["Docker Hub & App Packaging"]
        F2B["Fail2Ban Host Hardening"]
    end

    subgraph Pipelines["GitLab CI/CD Pipelines"]
        P1["Infrastructure Provisioning (Terraform/Packer)"]
        P2["Multi-Arch Container Builds (Docker Hub)"]
        P3["Production Deployment (OKE & Failover VM)"]
        P4["Automated DNS Failover Daemon"]
        P5["Runner Controller & Lifecycle"]
    end

    RepoVars --> Pipelines
```

---

## 2. Quick Reference Matrix

The following table summarizes all 29 repository environment variables required by the project pipelines, organized by functional domain:

| Domain | Variable | Masked | Protected | Description |
| :--- | :--- | :---: | :---: | :--- |
| **Cloud Providers** | [`OCI_CONFIG_BASE64`](#31-cloud-infrastructure--hashicorp-hcp) | Yes | No | Base64-encoded OCI CLI configuration file (`~/.oci/config`) |
| | [`OCI_PRIVATE_KEY_BASE64`](#31-cloud-infrastructure--hashicorp-hcp) | Yes | No | Base64-encoded OCI API PEM private key |
| | [`OCI_COMPARTMENT_OCID`](#31-cloud-infrastructure--hashicorp-hcp) | Yes | No | OCI Compartment OCID for resource allocation |
| | [`OCI_REGION`](#31-cloud-infrastructure--hashicorp-hcp) | Yes | No | Target OCI Region (e.g., `us-ashburn-1`) |
| | [`OCI_NAMESPACE`](#31-cloud-infrastructure--hashicorp-hcp) | Yes | No | OCI Object Storage tenancy namespace |
| | [`PACKER_WEBPORT_CLIENT_ID`](#31-cloud-infrastructure--hashicorp-hcp) | Yes | No | HashiCorp Cloud Platform (HCP) Service Principal Client ID |
| | [`PACKER_WEBPORT_CLIENT_SECRET`](#31-cloud-infrastructure--hashicorp-hcp) | Yes | No | HashiCorp Cloud Platform (HCP) Service Principal Client Secret |
| | [`TF_CLOUD_TOKEN`](#31-cloud-infrastructure--hashicorp-hcp) | Yes | No | HCP Terraform / Terraform Cloud API user token |
| **Cloudflare & DNS** | [`CLOUDFARE_API_TOKEN`](#32-cloudflare-dns--automated-failover) | Yes | No | Cloudflare API Token with `Zone.DNS:Edit` permissions |
| | [`CLOUDFARE_ZONE_ID`](#32-cloudflare-dns--automated-failover) | Yes | No | Cloudflare Zone ID for `yohrannes.com` |
| | [`CLFR_DNS_ID_WEBSITE`](#32-cloudflare-dns--automated-failover) | Yes | Yes | Cloudflare DNS record ID for the website A record |
| | [`FAILOVER_SCRIPT_URL`](#32-cloudflare-dns--automated-failover) | Yes | No | Direct URL to raw `webapp-failover-checker.sh` |
| **GitLab Automation** | [`GL_TOKEN_VARS_ADMIN`](#33-gitlab-runner-management--api-automation) | Yes | No | GitLab Personal Access Token with `api` scope |
| | [`GITLAB_TOKEN_RUNNER_ADMIN`](#33-gitlab-runner-management--api-automation) | Yes | No | GitLab token with admin access to manage runner instances |
| | [`GITLAB_RUNNER1_TOKEN_CREATED`](#33-gitlab-runner-management--api-automation) | Yes | No | Dynamic authentication token for Runner 1 (AMD64) |
| | [`GITLAB_RUNNER2_TOKEN_CREATED`](#33-gitlab-runner-management--api-automation) | Yes | No | Dynamic authentication token for Runner 2 (ARM64) |
| | [`GITLAB_RUNNER3_TOKEN_CREATED`](#33-gitlab-runner-management--api-automation) | Yes | No | Dynamic authentication token for Runner 3 (OKE Kubernetes) |
| **Network & Hosts** | [`SSH_PRIVATE_KEY_BASE64`](#34-target-hosts--network-connectivity) | Yes | No | Base64-encoded SSH private key for remote management |
| | [`PROD_RUNNER1_IP`](#34-target-hosts--network-connectivity) | Yes | No | Public IPv4 of Runner 1 VM instance |
| | [`PROD_RUNNER2_IP`](#34-target-hosts--network-connectivity) | Yes | No | Public IPv4 of Runner 2 VM instance |
| | [`PROD_WEBAPP_CLUSTER_ID`](#34-target-hosts--network-connectivity) | Yes | No | Dynamic OCID of the Oracle Kubernetes Engine (OKE) cluster |
| | [`PROD_WEBAPP_CLUSTER_IP`](#34-target-hosts--network-connectivity) | Yes | Yes | Dynamic public IP of the OKE Ingress Load Balancer |
| | [`PROD_WEBAPP_FAILOVER_IP`](#34-target-hosts--network-connectivity) | Yes | No | Public IPv4 of the OCI Compute Failover VM |
| **Packaging & Registry** | [`DOCKER_REG_USER`](#35-container-packaging--registry) | Yes | No | Docker Hub username |
| | [`DOCKER_REG_PASSWORD`](#35-container-packaging--registry) | Yes | No | Docker Hub Personal Access Token (PAT) |
| | [`IMAGE_TARGETS`](#35-container-packaging--registry) | No | No | Build targets matrix (`path|repository` pairs) |
| | [`APP_REP`](#35-container-packaging--registry) | Yes | No | Upstream application repository URL |
| | [`APP_REP_NAME`](#35-container-packaging--registry) | Yes | No | Upstream repository archive folder name |
| **Security & Hardening** | [`F2B_HTTP_INJ_FILTER_B64`](#36-host-security--intrusion-prevention) | Yes | No | Base64-encoded Fail2Ban HTTP injection filter |

---

## 3. Detailed Variable Specifications

### 3.1 Cloud Infrastructure & HashiCorp HCP

These variables provide programmatic access to Oracle Cloud Infrastructure (OCI) and HashiCorp Cloud Platform (HCP) for provisioning compute, networking, Kubernetes, and machine images.

#### `OCI_CONFIG_BASE64`
- **Purpose:** Decoded at runtime into `~/.oci/config` to authenticate the OCI CLI during OKE kubeconfig generation and image validation.
- **Format:** Base64-encoded string of standard INI format `[DEFAULT]` profile.
- **Referenced In:** [`pipelines/gitlab-ci-cd/cloud-auth/oci-oke-auth.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloud-auth/oci-oke-auth.yml), [`pipelines/gitlab-ci-cd/packer/build-instance-image.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/packer/build-instance-image.yml).

#### `OCI_PRIVATE_KEY_BASE64`
- **Purpose:** Decoded at runtime into `~/.oci/oci_api_key.pem` with restrictive permissions (`chmod 600`). Required by OCI API client authentication.
- **Format:** Base64-encoded RSA/OpenSSL private key in PEM format (`-----BEGIN PRIVATE KEY-----`).
- **Referenced In:** [`pipelines/gitlab-ci-cd/cloud-auth/oci-oke-auth.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloud-auth/oci-oke-auth.yml), [`pipelines/gitlab-ci-cd/packer/build-instance-image.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/packer/build-instance-image.yml).

#### `OCI_COMPARTMENT_OCID`
- **Purpose:** Identifies the target compartment under which compute instances, VCNs, and images are organized. Exported to Terraform as `TF_VAR_compartment_id`.
- **Format:** String matching `ocid1.compartment.oc1..[a-z0-9]+` or tenancy root `ocid1.tenancy.oc1..[a-z0-9]+`.
- **Referenced In:** [`pipelines/gitlab-ci-cd/packer/build-instance-image.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/packer/build-instance-image.yml).

#### `OCI_REGION`
- **Purpose:** Specifies the target Oracle Cloud data center region (e.g., `us-ashburn-1`). Exported to Terraform as `TF_VAR_region`.
- **Format:** String identifier (e.g., `us-ashburn-1`).
- **Referenced In:** [`pipelines/gitlab-ci-cd/packer/build-instance-image.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/packer/build-instance-image.yml).

#### `OCI_NAMESPACE`
- **Purpose:** Tenancy-specific namespace required for OCI Object Storage API endpoints and bucket verification.
- **Format:** Lowercase alphanumeric string identifier.
- **Referenced In:** [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml), [`pipelines/gitlab-ci-cd/tests/infra-webapp/infra-webapp.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/tests/infra-webapp/infra-webapp.yml).

#### `PACKER_WEBPORT_CLIENT_ID`
- **Purpose:** HashiCorp Cloud Platform (HCP) Service Principal Client ID, used by Packer to authenticate and push build metadata to HCP Packer Registry.
- **Format:** Alphanumeric identifier string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/packer/build-instance-image.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/packer/build-instance-image.yml).

#### `PACKER_WEBPORT_CLIENT_SECRET`
- **Purpose:** HCP Service Principal Secret corresponding to the Client ID.
- **Format:** Alphanumeric token string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/packer/build-instance-image.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/packer/build-instance-image.yml).

#### `TF_CLOUD_TOKEN`
- **Purpose:** API bearer token for HCP Terraform (Terraform Cloud). Grants permission to create configuration versions, trigger plan/apply runs, poll run status, and retrieve state outputs.
- **Format:** Alphanumeric user or team API token from `app.terraform.io`.
- **Referenced In:** [`pipelines/gitlab-ci-cd/terraform/apply.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/terraform/apply.yml), [`pipelines/gitlab-ci-cd/terraform/trigger-run.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/terraform/trigger-run.yml), [`pipelines/gitlab-ci-cd/terraform/get-output.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/terraform/get-output.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml), [`pipelines/gitlab-ci-cd/infra-webapp/infra-webapp.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-webapp/infra-webapp.yml), [`pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml), [`pipelines/gitlab-ci-cd/packer/build-instance-image.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/packer/build-instance-image.yml).

---

### 3.2 Cloudflare DNS & Automated Failover

The high-availability architecture provides automatic DNS redirection between the primary Kubernetes cluster (OKE) and the standby Compute Failover VM.

#### `CLOUDFARE_API_TOKEN`
- **Purpose:** Cloudflare API token scoped to `Zone:DNS:Edit`. Used by the automated health check daemon to update DNS records when a service degradation or recovery is detected.
- **Format:** 40-character Bearer token string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml).

#### `CLOUDFARE_ZONE_ID`
- **Purpose:** Identifies the Cloudflare DNS zone for `yohrannes.com`.
- **Format:** 32-character hexadecimal string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml).

#### `CLFR_DNS_ID_WEBSITE`
- **Purpose:** Identifier of the specific root A record (`@`) pointing to the active web ingress. Updated dynamically during failover transitions.
- **Format:** 32-character hexadecimal string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml).

#### `FAILOVER_SCRIPT_URL`
- **Purpose:** Raw repository URL from which the runner downloads the latest `webapp-failover-checker.sh` daemon script.
- **Format:** HTTP/HTTPS URL string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml).

---

### 3.3 GitLab Runner Management & API Automation

These variables enable pipeline jobs to interact with GitLab's own REST API to register runners, clean up decommissioned runners, and update dynamic runtime state.

#### `GL_TOKEN_VARS_ADMIN`
- **Purpose:** GitLab Personal Access Token (PAT) with `api` scope. Required by pipeline jobs to update project variables dynamically (such as newly allocated IPs and cluster IDs) via `PUT /api/v4/projects/:id/variables/:key`.
- **Format:** String prefixed with `glpat-`.
- **Referenced In:** [`pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml), [`pipelines/gitlab-ci-cd/infra-webapp/infra-webapp.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-webapp/infra-webapp.yml), [`pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml), [`pipelines/gitlab-ci-cd/terraform/get-output.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/terraform/get-output.yml).

#### `GITLAB_TOKEN_RUNNER_ADMIN`
- **Purpose:** Administrative token with privileges to query, unregister, and clean up runner instances via `/api/v4/user/runners` during runner provisioning cycles.
- **Format:** GitLab administrative access token.
- **Referenced In:** [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml).

#### `GITLAB_RUNNER1_TOKEN_CREATED`
- **Purpose:** **(Dynamic)** Authentication token assigned to Runner 1 (`x86_64`). Created and maintained automatically by the runner setup job.
- **Format:** String prefixed with `glrt-`.
- **Referenced In:** [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml).

#### `GITLAB_RUNNER2_TOKEN_CREATED`
- **Purpose:** **(Dynamic)** Authentication token assigned to Runner 2 (`aarch64`). Created and maintained automatically by the runner setup job.
- **Format:** String prefixed with `glrt-`.
- **Referenced In:** [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml).

#### `GITLAB_RUNNER3_TOKEN_CREATED`
- **Purpose:** **(Dynamic)** Authentication token assigned to Runner 3 (OKE Kubernetes pod runner). Created and maintained automatically by the runner setup job.
- **Format:** String prefixed with `glrt-`.
- **Referenced In:** [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml).

---

### 3.4 Target Hosts & Network Connectivity

These variables configure SSH credentials and track target IP endpoints across deployments.

#### `SSH_PRIVATE_KEY_BASE64`
- **Purpose:** Base64-encoded OpenSSH private key used to open non-interactive SSH sessions to compute instances during deployment and setup stages.
- **Format:** Base64-encoded OpenSSH private key (`-----BEGIN OPENSSH PRIVATE KEY-----`).
- **Referenced In:** [`pipelines/gitlab-ci-cd/prod.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/prod.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml), [`pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml).

#### `PROD_RUNNER1_IP`
- **Purpose:** Public IPv4 address of the dedicated Runner 1 VM host. Used to initiate SSH setup and runner registration commands.
- **Format:** Standard IPv4 address string (e.g., `129.x.x.x`).
- **Referenced In:** [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner1.yml).

#### `PROD_RUNNER2_IP`
- **Purpose:** Public IPv4 address of the dedicated Runner 2 VM host. Verified via ping reachability tests and refreshed from Terraform output.
- **Format:** Standard IPv4 address string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml), [`pipelines/gitlab-ci-cd/tests/infra-webapp/infra-webapp.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/tests/infra-webapp/infra-webapp.yml).

#### `PROD_WEBAPP_CLUSTER_ID`
- **Purpose:** **(Dynamic)** OCID of the Oracle Kubernetes Engine (OKE) cluster. Queried from Terraform outputs and passed to `oci ce cluster create-kubeconfig` to generate local cluster credentials.
- **Format:** String matching `ocid1.cluster.oc1.[region].[id]`.
- **Referenced In:** [`pipelines/gitlab-ci-cd/cloud-auth/oci-oke-auth.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloud-auth/oci-oke-auth.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner3.yml), [`pipelines/gitlab-ci-cd/infra-webapp/infra-webapp.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-webapp/infra-webapp.yml).

#### `PROD_WEBAPP_CLUSTER_IP`
- **Purpose:** **(Dynamic)** Public IP address of the primary OKE Load Balancer (Nginx Gateway Fabric). Read from Kubernetes service status and updated in GitLab for DNS failover tracking.
- **Format:** Standard public IPv4 address string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml), [`pipelines/gitlab-ci-cd/infra-webapp/infra-webapp.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-webapp/infra-webapp.yml).

#### `PROD_WEBAPP_FAILOVER_IP`
- **Purpose:** Public IPv4 address of the standalone OCI Failover VM. Target of the Docker Compose production deployment job and the secondary DNS fallback target.
- **Format:** Standard public IPv4 address string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/prod.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/prod.yml), [`pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/cloudfare/dns-failover.yml), [`pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-gitlab-runners/runner2.yml), [`pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/infra-webapp/infra-webapp-failover.yml).

---

### 3.5 Container Packaging & Registry

These variables manage multi-architecture container image builds (`linux/amd64` and `linux/arm64`) and publication to Docker Hub.

#### `DOCKER_REG_USER`
- **Purpose:** Docker Hub account username (`yohrannes`). Used during the `docker login` phase of container image publication.
- **Format:** Alphanumeric username string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/docker-images/docker-registry.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/docker-images/docker-registry.yml).

#### `DOCKER_REG_PASSWORD`
- **Purpose:** Docker Hub Personal Access Token (PAT) with Read/Write permissions used with `docker login --password-stdin`.
- **Format:** Alphanumeric PAT string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/dev.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/dev.yml), [`pipelines/gitlab-ci-cd/docker-images/docker-registry.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/docker-images/docker-registry.yml).

#### `IMAGE_TARGETS`
- **Purpose:** Defines the matrix of Docker build contexts and corresponding target Docker Hub repository names. Parsed in loops by build jobs.
- **Format:** Multiline newline-separated string formatted as `<folder-path>|<image-repository>`:
  ```text
  docker-compose/webport|yohrannes/website-portifolio
  docker-compose/nginx|yohrannes/nginx
  ```
- **Referenced In:** [`pipelines/gitlab-ci-cd/docker-images/docker-registry.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/docker-images/docker-registry.yml).

#### `APP_REP`
- **Purpose:** Upstream application Git repository URL from which application assets and templates are retrieved during image builds.
- **Format:** URL string (e.g., `https://github.com/yohrannes/yohrannes.com`).
- **Referenced In:** [`pipelines/gitlab-ci-cd/docker-images/docker-registry.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/docker-images/docker-registry.yml).

#### `APP_REP_NAME`
- **Purpose:** Base directory name of the unpacked application archive (e.g., `yohrannes.com`) used to strip path components during tar extraction.
- **Format:** Alphanumeric string.
- **Referenced In:** [`pipelines/gitlab-ci-cd/docker-images/docker-registry.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/docker-images/docker-registry.yml).

---

### 3.6 Host Security & Intrusion Prevention

#### `F2B_HTTP_INJ_FILTER_B64`
- **Purpose:** Base64-encoded Fail2Ban filter configuration (`http-injection.conf`). Decoded onto the host to protect Nginx and Flask containers against SQL injection, path traversal, and malicious user agents.
- **Format:** Base64-encoded Fail2Ban filter rule file.
- **Referenced In:** [`pipelines/gitlab-ci-cd/prod.yml`](file:///home/yohrannes/repos-git/website-portifolio/pipelines/gitlab-ci-cd/prod.yml).

---

## 4. Pipeline-Level Static Configuration

The following variables are defined statically within [.gitlab-ci.yml](file:///home/yohrannes/repos-git/website-portifolio/.gitlab-ci.yml). They are tracked in version control and **do not require manual configuration** in GitLab CI/CD Settings:

| Variable | Configured Value | Purpose |
| :--- | :--- | :--- |
| `TZ` | `America/Sao_Paulo` | Standard timezone for container runtime logs. |
| `TF_CLOUD_ORG` | `org-website-portifolio` | HCP Terraform organization name. |
| `TF_CLOUD_API` | `https://app.terraform.io/api/v2` | HCP Terraform REST API base URL. |
| `MAX_RETRIES` | `9` | Maximum polling iterations for Terraform Cloud run states. |
| `RETRY_DELAY` | `10` | Wait interval (in seconds) between Terraform status checks. |
| `PLAN_TIMEOUT` | `1800` | Timeout threshold (30 minutes) for Terraform plan generation. |
| `APPLY_TIMEOUT` | `3600` | Timeout threshold (60 minutes) for Terraform apply execution. |
| `APPLY_TRIGGER_MAX_ATTEMPTS` | `90` | Retries when waiting for an active workspace lock to release. |
| `APPLY_TRIGGER_RETRY_DELAY` | `5` | Polling interval (seconds) while waiting for workspace release. |
| `TF_ROOT` | `${CI_PROJECT_DIR}/iac/terraform/prod` | Working directory containing the production Terraform manifests. |
| `TF_CONFIG_FILE` | `terraform-config.tar.gz` | Filename used when bundling configuration for Terraform Cloud. |

---

## 5. Provisioning Guide with the `glab` CLI

To configure or update repository variables from your local terminal, use the official `glab` CLI tool:

### 5.1 Setting a Masked Secret
```bash
# General masked secret
glab variable set TF_CLOUD_TOKEN --value "atlasv1.token..." --masked

# Multi-line Base64 credential
glab variable set OCI_CONFIG_BASE64 --value "$(base64 -w0 ~/.oci/config)" --masked
glab variable set OCI_PRIVATE_KEY_BASE64 --value "$(base64 -w0 ~/.oci/oci_api_key.pem)" --masked
glab variable set SSH_PRIVATE_KEY_BASE64 --value "$(base64 -w0 ~/.ssh/id_rsa)" --masked
```

### 5.2 Setting a Protected Secret
Protected variables are only passed to pipelines running on protected branches (such as `main`):
```bash
glab variable set CLFR_DNS_ID_WEBSITE --value "record_id" --masked --protected
glab variable set PROD_WEBAPP_CLUSTER_IP --value "157.x.x.x" --masked --protected
```

### 5.3 Listing and Verifying Variables
```bash
glab variable list
```

---

## 6. Security & Operational Best Practices

1. **Mandatory Value Masking:** All API tokens, passwords, private keys, and external IP addresses must have `masked: true` configured. This prevents credentials from appearing in raw job console logs.
2. **Base64 Encoding Integrity:** Multi-line configuration files and PEM keys must always be Base64-encoded to avoid line termination stripping or whitespace truncation during GitLab variable expansion.
3. **Scoped Tokens:**
   - `GL_TOKEN_VARS_ADMIN` must be scoped strictly to the current project's `api` endpoint.
   - `CLOUDFARE_API_TOKEN` must be restricted to `Zone:DNS:Edit` for `yohrannes.com`.
   - `TF_CLOUD_TOKEN` must have permissions restricted to the `org-website-portifolio` organization.
4. **Dynamic State Protection:** Variables populated programmatically by pipeline jobs (such as `PROD_WEBAPP_CLUSTER_ID` and `PROD_WEBAPP_CLUSTER_IP`) should be treated as operational state and never manually modified while pipeline jobs are running.
