# GitLab authentication

GitLab is used as the source of truth for the CI/CD pipeline, for runner registration, and for the variables that give the project access to Docker images and other secret values.

## Why this is required

The repository defines multiple GitLab pipeline includes and uses GitLab variables such as `GITLAB_TOKEN`, `GITLAB_TOKEN_RUNNER_ADMIN`, and `DOCKER_REG_PASSWORD`. The project also relies on runner registration for infrastructure automation and deployment.

## Manual steps

1. Log in to GitLab with the required account.
2. Create or access the target project.
3. Generate access tokens or PATs when needed.
4. Register the GitLab runners.
5. Define the project variables used by the pipeline.

## CLI commands

```bash
glab auth login
glab auth status
glab variable set DOCKER_REG_PASSWORD --value "<secret>"
glab variable set GITLAB_TOKEN --value "<token>"
glab variable set TF_API_TOKEN --value "<token>"
```

## Required tokens and variables

The project uses the following pattern in CI and shell scripts:
- `GITLAB_TOKEN`
- `GITLAB_TOKEN_RUNNER_ADMIN`
- `DOCKER_REG_PASSWORD`
- `PRIVATE-TOKEN` in API requests
- additional project variables required by CI jobs

## Official documentation

- GitLab CI/CD variables: https://docs.gitlab.com/ci/variables/
- GitLab Runner registration: https://docs.gitlab.com/runner/register/
- Project access tokens: https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html

## What is manual vs automated

Manual:
- user login and project access
- runner registration and admin setup
- secret creation in GitLab project settings

Automated by CI/CD or scripts:
- variable-based deployment logic
- Docker registry authentication in pipeline jobs
- API calls to GitLab for variable management and runner coordination
