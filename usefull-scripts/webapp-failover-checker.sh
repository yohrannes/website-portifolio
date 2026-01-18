#!/bin/bash

CLUSTER_IP=$1
FAILOVER_IP=$1

webapp_cluster_status=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: yohrannes.com" "http://$CLUSTER_IP")

webapp_failover_status=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: yohrannes.com" "http://$FAILOVER_IP")

if [ webapp_cluster_status == "200" ]; then
  curl --request PUT \
  --url "https://api.cloudflare.com/client/v4/zones/$CLOUDFARE_ZONE_ID/dns_records/$CLFR_DNS_ID_OCI_INST_YO_COM" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $CLOUDFARE_API_TOKEN" \
  --data '{
    "comment": "Domain verification record",
    "name": "yohrannes.com",
    "proxied": true,
    "settings": {},
    "tags": [],
    "ttl": 1,
    "content": "'"$CLUSTER_IP"'",
    "type": "A"
  }' | jq '.'
else
  curl --request PUT \
  --url "https://api.cloudflare.com/client/v4/zones/$CLOUDFARE_ZONE_ID/dns_records/$CLFR_DNS_ID_OCI_INST_YO_COM" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $CLOUDFARE_API_TOKEN" \
  --data '{
    "comment": "Domain verification record",
    "name": "yohrannes.com",
    "proxied": true,
    "settings": {},
    "tags": [],
    "ttl": 1,
    "content": "'"$FAILOVER_IP"'",
    "type": "A"
  }' | jq '.'
fi

### */5 * * * * /path/to/webapp-failover-checker.sh