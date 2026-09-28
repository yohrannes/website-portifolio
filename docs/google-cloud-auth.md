# Google Cloud authentication

This project uses Google Cloud for the infrastructure bootstrap flow described in the project documentation. The local user must authenticate the Google Cloud CLI before provisioning resources or creating the GitLab runner infrastructure.

## Why this is required

The project documentation lists Google Cloud as a required authentication target for local infrastructure creation. The main commands used by the project and the environment setup are based on the Google Cloud SDK.

## Manual steps

1. Install the Google Cloud SDK.
2. Sign in with the target Google account.
3. Select the correct project.
4. Verify that the default application credentials are available when needed.

## CLI commands

```bash
gcloud auth login
gcloud config set project <PROJECT_ID>
gcloud auth application-default login
gcloud components install gcloud-cli
```

## Required tokens and variables

The repository does not hardcode a Google Cloud token in source files. The setup relies on the local user session and the Google Cloud SDK's authenticated context.

Typical values required by the local environment:
- project ID
- region/zone
- service account or application default credentials if used for automation

## Official documentation

- Google Cloud SDK installation: https://cloud.google.com/sdk/docs/install
- Google Cloud SDK authorization: https://cloud.google.com/sdk/docs/authorizing
- Quickstart: https://cloud.google.com/sdk/docs/quickstart

## What is manual vs automated

Manual:
- account, project, and API setup
- installing the SDK
- user login and project selection

Automated by CI/CD or scripts:
- the runner/bootstrap scripts expect the SDK to be already configured in the execution environment
