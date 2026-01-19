#!/bin/bash

CLUSTER_IP=$1
FAILOVER_IP=$2

webapp_cluster_status=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: yohrannes.com" "http://$CLUSTER_IP")

if [[ $webapp_cluster_status == "200" ]]; then
  echo "Cluster Online - 200"
else
  echo "Cluster Offline - 200 updating ip to failover instance."
  curl --request PUT \
  --url "https://api.cloudflare.com/client/v4/zones/$CLOUDFARE_ZONE_ID/dns_records/CLFR_DNS_ID_OCI_INST_GRAF_DEV_YO_COM" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $CLOUDFARE_API_TOKEN" \
  --data '{
    "comment": "Domain verification record",
    "name": "dev.yohrannes.com",
    "proxied": true,
    "settings": {},
    "tags": [],
    "ttl": 1,
    "content": "'"$FAILOVER_IP"'",
    "type": "A"
  }' | jq '.'
fi

#webapp_failover_status=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: yohrannes.com" "http://$FAILOVER_IP")
### */5 * * * * /path/to/webapp-failover-checker.sh $(k get svc -n nginx-gateway -o json | jq -r '.items[0].status.loadBalancer.ingress[0].ip')