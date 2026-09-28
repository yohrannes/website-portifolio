# Terraform Cloud authentication

Terraform Cloud is used to manage the project infrastructure state and to coordinate the provisioning workflow. The project references Terraform Cloud organization variables and API tokens in its pipeline configuration.

## Why this is required

The project declares Terraform Cloud metadata in the main pipeline and expects the user or environment to have a valid organization, workspace, and API token configured before running apply/plan workflows.

## Manual steps

1. Create a Terraform Cloud organization.
2. Create the target workspace.
3. Generate a user or team API token.
4. Configure workspace variables and environment values.
5. Authenticate Terraform locally if needed.

## CLI commands

```bash
terraform login
export TF_API_TOKEN="<token>"
terraform init
terraform plan
terraform apply
```

## Required tokens and variables

The project uses variables such as:
- `TF_CLOUD_ORG`
- `TF_CLOUD_API`
- `TF_API_TOKEN`
- `TF_ROOT`
- `TF_CONFIG_FILE`

These appear in the main GitLab CI configuration and the Terraform documentation for the project.

## Official documentation

- Terraform Cloud users and organizations: https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/users
- Terraform CLI configuration: https://developer.hashicorp.com/terraform/cli/config/config-file
- Terraform Cloud workspaces: https://developer.hashicorp.com/terraform/cloud-docs/workspaces

## What is manual vs automated

Manual:
- creating the org and workspace
- token issuance and workspace configuration
- storing tokens in a secure secret manager or local environment

Automated by CI/CD or scripts:
- `terraform init`, `plan`, and `apply` execution through GitLab CI
- workspace-driven infrastructure lifecycle orchestration
