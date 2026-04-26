#!/bin/bash

set -x

CLUSTER_IP=$1
FAILOVER_IP=$2

echo "Cluster IP: $CLUSTER_IP"
echo "Failover IP: $FAILOVER_IP"

webapp_cluster_status=$(\
  curl \
    -s -o /dev/null \
    -w "%{http_code}" \
    -H "Host: dev.yohrannes.com" "http://$CLUSTER_IP"\
) # webapp status on cluster

webapp_ip=$(\
  curl \
    --request GET \
    --url "https://api.cloudflare.com/client/v4/zones/$CLOUDFARE_ZONE_ID/dns_records/$CLFR_DNS_ID_OCI_INST_YO_COM" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $CLOUDFARE_API_TOKEN" | jq -r '.result.content'\
) ### cluster ip or failover ip

if [[ $webapp_cluster_status == "200" ]]; then
  echo "Cluster Online - 200"
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
  if [[ $webapp_ip != $CLUSTER_IP ]]; then ## && [[ $webapp_ip == $FAILOVER_IP ]]; then
    echo "Failover enabled..."
  else
    curl \
      --request PUT \
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
    echo "Cluster Offline - enabled failover instance."
  fi
fi

# k get svc -n nginx-gateway -o json | jq -r '.items[0].status.loadBalancer.ingress[0].ip'
### */1 * * * * /bin/bash /home/ubuntu/repos-git/website-portifolio/usefull-scripts/webapp-failover-checker.sh "<CLUSTER_IP>" "<FAILOVER_IP>" > /var/log/webapp-failover-checker.log 2>&1
