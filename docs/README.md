# Project onboarding and authentication guide

This document consolidates the required local setup for the `website-portifolio` project and links the provider-specific guides that describe authentication and setup in more detail.

## Scope

The project requires authenticated access to multiple platforms before infrastructure provisioning, runner registration, image builds, and DNS failover can operate correctly.

The required providers are:

- Google Cloud
- Oracle Cloud Infrastructure
- Terraform Cloud
- GitLab
- HashiCorp Packer
- Cloudflare

## Provider-specific guides

- [Google Cloud authentication](./google-cloud-auth.md)
- [Oracle Cloud Infrastructure authentication](./oracle-cloud-auth.md)
- [Terraform Cloud authentication](./terraform-cloud-auth.md)
- [GitLab authentication](./gitlab-auth.md)
- [Packer authentication](./packer-auth.md)
- [Cloudflare authentication](./cloudflare-auth.md)

---

## Prerequisites

Before running the project flow, confirm that the local machine has:

- Docker and Docker Compose installed
- Git installed
- Terraform CLI installed
- Google Cloud SDK installed
- OCI CLI installed
- GitLab CLI (`glab`) installed
- HashiCorp Packer installed
- access to the target cloud accounts and active user sessions

---

## Required manual authentication checklist

### 1. Google Cloud

Required for:
- instance creation
- environment bootstrap
- support for the local cloud CLI workflow

Checklist:
- [ ] install Google Cloud SDK
- [ ] run `gcloud auth login`
- [ ] select the target project with `gcloud config set project <PROJECT_ID>`
- [ ] verify local authentication with `gcloud auth list`

Official docs:
- https://cloud.google.com/sdk/docs/install
- https://cloud.google.com/sdk/docs/authorizing
- https://cloud.google.com/sdk/docs/quickstart

### 2. Oracle Cloud Infrastructure

Required for:
- instance creation
- cluster creation
- OCI-based provisioning and failover environment

Checklist:
- [ ] install OCI CLI
- [ ] create the OCI user and tenancy configuration
- [ ] generate API keys and place them under `~/.oci`
- [ ] configure `~/.oci/config`
- [ ] authenticate the session with `oci session authenticate`
- [ ] validate the session with `oci session validate`

Official docs:
- https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm
- https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/clisetup.htm
- https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliauthentication.htm

### 3. Terraform Cloud

Required for:
- workspace management
- Terraform state coordination
- API token-based apply/plan automation

Checklist:
- [ ] create Terraform Cloud organization
- [ ] create the workspace
- [ ] generate API token
- [ ] configure workspace variables
- [ ] run `terraform login`
- [ ] export `TF_API_TOKEN` when needed

Official docs:
- https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/users
- https://developer.hashicorp.com/terraform/cli/config/config-file
- https://developer.hashicorp.com/terraform/cloud-docs/workspaces

### 4. GitLab

Required for:
- project variables
- runner registration
- CI/CD authentication
- container registry login and pipeline access

Checklist:
- [ ] log in to GitLab with the correct account
- [ ] create or select the project
- [ ] generate access tokens or PATs where required
- [ ] register runners
- [ ] configure project variables such as `GITLAB_TOKEN`, `GITLAB_TOKEN_RUNNER_ADMIN`, and `DOCKER_REG_PASSWORD`

Official docs:
- https://docs.gitlab.com/ci/variables/
- https://docs.gitlab.com/runner/register/
- https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html

### 5. HashiCorp Packer

Required for:
- image creation
- OCI image builds for the provisioned environment

Checklist:
- [ ] install Packer
- [ ] run `packer login` if required by the infrastructure workflow
- [ ] ensure OCI credentials are available for the Oracle builder
- [ ] run `packer init .` and `packer build .`

Official docs:
- https://developer.hashicorp.com/packer/docs/commands/login
- https://developer.hashicorp.com/packer/plugins/builders/oracle/oci
- https://developer.hashicorp.com/packer/docs/plugins

### 6. Cloudflare

Required for:
- DNS updates
- failover routing and traffic redirection

Checklist:
- [ ] create or access Cloudflare account
- [ ] generate API token with DNS permissions
- [ ] collect `CLOUDFARE_ZONE_ID`
- [ ] identify the DNS record IDs to update
- [ ] configure environment variables used by the failover checker

Official docs:
- https://developers.cloudflare.com/fundamentals/api/get-started/keys/
- https://developers.cloudflare.com/api/
- https://developers.cloudflare.com/dns/

---

## Variables and secrets that the project expects

The repository and pipeline reference the following values as part of the deployment lifecycle:

- `GITLAB_TOKEN`
- `GITLAB_TOKEN_RUNNER_ADMIN`
- `DOCKER_REG_PASSWORD`
- `TF_CLOUD_ORG`
- `TF_CLOUD_API`
- `TF_API_TOKEN`
- `CLOUDFARE_API_TOKEN`
- `CLOUDFARE_ZONE_ID`
- `CLFR_DNS_ID_OCI_INST_YO_COM`
- `PROD_WEBAPP_FAILOVER_IP`
- `PROD_WEBAPP_CLUSTER_IP`
- `PACKER_WEBPORT_CLIENT_ID`
- `PACKER_WEBPORT_CLIENT_SECRET`

These are expected to be provided by the user or by GitLab CI/CD variables, rather than embedded directly in source code.

---

## Project execution sequence

The infrastructure and deployment workflow is organized in this order:

1. runner1.yml — create the Google Cloud instance and configure a GitLab runner
2. infra-webapp-failover.yml — create the Oracle Cloud failover instance
3. runner2.yml — configure the failover instance also as a GitLab runner
4. infra-webapp.yml — create the Oracle Cloud cluster that hosts the portfolio
5. runner3.yml — configure the cluster also as a Gitlab runner
6. dev.yml — develop and publish Docker images to the registry
7. prod.yml — deploy the site to the instance and cluster

---

## Pipeline structure

```text
pipelines/
└── gitlab-ci-cd/
    ├── cloud-auth/
    │   └── oci-oke-auth.yml
    ├── dev.yml
    ├── docker-images/
    │   └── docker-registry.yml
    ├── infra-gitlab-runners/
    │   ├── runner1.yml
    │   ├── runner2.yml
    │   ├── runner3.yml
    │   └── runner-controler.yml
    ├── infra-webapp/
    │   ├── infra-webapp-failover.yml
    │   └── infra-webapp.yml
    ├── packer/
    │   └── build-instance-image.yml
    ├── prod.yml
    ├── terraform/
    │   ├── apply.yml
    │   ├── get-output.yml
    │   ├── note.txt
    │   └── trigger-run.yml
    └── tests/
        └── infra-webapp/
            └── infra-webapp.yml
```

---

## Manual setup vs automation

Manual setup is required for:
- account creation
- cloud login
- token generation
- workspace configuration
- runner registration
- secret storage in GitLab or cloud providers

Automated by pipeline scripts:
- Terraform apply/plan execution
- OCI session validation
- GitLab variable-based access
- Docker image publishing
- failover check and DNS update in the runtime environment

---

## Final onboarding checklist

Before starting the full infrastructure flow, confirm that all of the following are true:

- [ ] Google Cloud login is valid
- [ ] OCI CLI is installed and authenticated
- [ ] Terraform Cloud organization and workspace are ready
- [ ] GitLab project access and runner registration are complete
- [ ] Packer credentials are configured for OCI and related providers
- [ ] Cloudflare token and DNS records are configured
- [ ] required GitLab CI variables are already defined
- [ ] Docker, Git, Terraform, and cloud CLIs are installed locally

This checklist is the minimum requirement before the project can be safely executed end-to-end.