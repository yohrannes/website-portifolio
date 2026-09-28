# Packer and HashiCorp authentication

Packer is used for image creation and local infrastructure packaging. The project includes Packer configuration for Oracle Cloud image generation and references the need for authenticated provider credentials before building.

## Why this is required

The Packer build source in the repository includes Oracle Cloud builder settings and expects the provider credentials to be available to the local environment or the runner. The project also references HashiCorp secrets and Packer login in its setup flow.

## Manual steps

1. Install HashiCorp Packer.
2. Authenticate to the Packer registry or required backend when applicable.
3. Ensure provider credentials for Oracle Cloud are available.
4. Run `packer init` and `packer build` with the proper variables.

## CLI commands

```bash
packer login
packer init .
packer build .
```

## Required tokens and variables

The project references values such as:
- `PACKER_WEBPORT_CLIENT_ID`
- `PACKER_WEBPORT_CLIENT_SECRET`
- Oracle Cloud fields such as `compartment_ocid`, `subnet_ocid`, `availability_domain`, and `key_file`

These values show up in the infrastructure documentation and the Packer source configuration.

## Official documentation

- Packer login: https://developer.hashicorp.com/packer/docs/commands/login
- Oracle OCI builder: https://developer.hashicorp.com/packer/plugins/builders/oracle/oci
- Packer plugins: https://developer.hashicorp.com/packer/docs/plugins

## What is manual vs automated

Manual:
- installing the tool
- preparing provider credentials
- defining the variables used by the Oracle builder

Automated by CI/CD or scripts:
- image build execution once credentials are available in the environment
- artifact generation used by the infrastructure workflow
