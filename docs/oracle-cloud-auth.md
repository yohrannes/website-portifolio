# Oracle Cloud Infrastructure (OCI) authentication

This project relies on Oracle Cloud Infrastructure for the failover environment, cluster, and infrastructure provisioning flow. The documented setup requires both local CLI authentication and OCI session setup before Terraform or runner automation can operate.

## Why this is required

The project references OCI as a core cloud target and the local environment is expected to have an authenticated OCI CLI profile. The Terraform and infrastructure scripts are designed around OCI session authentication and the user profile in `~/.oci/config`.

## Manual steps

1. Install the OCI CLI.
2. Create a user, tenancy, and compartment in OCI.
3. Generate API keys and store them in `~/.oci`.
4. Configure the CLI profile.
5. Authenticate the session for the target region.

## CLI commands

```bash
oci -v
oci setup config
oci session authenticate --region us-ashburn-1 --profile-name DEFAULT
oci session validate --config-file ~/.oci/config --profile DEFAULT --auth security_token
oci session refresh --config-file ~/.oci/config --profile DEFAULT --auth security_token
```

## Required tokens and variables

The project scripts reference OCI session-based authentication rather than static secret strings in source files. Typical values include:
- tenancy OCID
- user OCID
- fingerprint
- private key path
- region
- compartment OCID
- profile name

The OCI scripts in the repository rely on the authenticated profile and user environment, for example in the OKE helper scripts.

## Official documentation

- OCI CLI installation: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm
- OCI CLI setup: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/clisetup.htm
- OCI CLI authentication: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliauthentication.htm

## What is manual vs automated

Manual:
- tenancy and compartment setup
- API key generation and config file creation
- user login and regional session creation

Automated by CI/CD or scripts:
- session validation and refresh in OCI helper scripts
- cluster and provisioning commands that assume the OCI profile is already authenticated
