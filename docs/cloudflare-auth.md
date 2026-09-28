# Cloudflare authentication

Cloudflare is used in the project for DNS management and for the failover logic that redirects traffic between the active instance and the recovery path.

## Why this is required

The project includes Cloudflare variables and a failover script that calls Cloudflare API endpoints to update DNS records. This means the user must have a valid Cloudflare account, token, zone, and DNS record IDs configured before the failover flow can work.

## Manual steps

1. Create or access a Cloudflare account.
2. Generate an API token with the required DNS permissions.
3. Identify the target zone and DNS record IDs.
4. Configure the environment variables used by the failover checker.

## CLI/API commands

```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN"

curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$CLOUDFARE_ZONE_ID/dns_records/$CLFR_DNS_ID_OCI_INST_YO_COM" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"type":"A","name":"@","content":"<IP>","ttl":1,"proxied":false}'
```

## Required tokens and variables

The failover script expects the following values:
- `CLOUDFARE_ZONE_ID`
- `CLOUDFARE_API_TOKEN`
- `CLFR_DNS_ID_OCI_INST_YO_COM`
- `PROD_WEBAPP_FAILOVER_IP`
- `PROD_WEBAPP_CLUSTER_IP`
- `GL_TOKEN_VARS_ADMIN`

## Official documentation

- Cloudflare API keys: https://developers.cloudflare.com/fundamentals/api/get-started/keys/
- Cloudflare API documentation: https://developers.cloudflare.com/api/
- Cloudflare DNS documentation: https://developers.cloudflare.com/dns/

## What is manual vs automated

Manual:
- creating the token and account access
- identifying the zone and record IDs
- setting the environment variables

Automated by CI/CD or scripts:
- DNS change execution through the failover checker
- health-based traffic switching logic triggered by cron or runner automation
