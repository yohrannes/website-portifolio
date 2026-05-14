#!/bin/bash

set -x

#CLUSTER_IP=$1
#FAILOVER_IP=$2

CLUSTER_IP=$(curl \
  -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN_RUNNER_ADMIN" \
  "https://gitlab.com/api/v4/projects/$CI_PROJECT_ID/variables/PROD_WEBAPP_CLUSTER_IP" \
  | jq -r '.value')

FAILOVER_IP=$(curl \
  -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN_RUNNER_ADMIN" \
  "https://gitlab.com/api/v4/projects/$CI_PROJECT_ID/variables/PROD_WEBAPP_FAILOVER_IP" \
  | jq -r '.value')
  
### Get cluster and failover ip direct from gitlab vars api using gitlab token.
### This script needs to be independent of the pipeline arguments.
### The ip values need to be continuous obtained using cronjob.
### Gitlab API limitation is 2000 api requests per minute. - thats ok

echo "Cluster IP: $CLUSTER_IP"
echo "Failover IP: $FAILOVER_IP"

webapp_cluster_status=$(\
  curl \
    -s -o /dev/null \
    -w "%{http_code}" \
    -H "Host: yohrannes.com" "http://$CLUSTER_IP"\
) # webapp status on cluster

webapp_failover_instance_status=$(\
  curl \
    -s -o /dev/null \
    -w "%{http_code}" \
    -H "Host: yohrannes.com" "http://$FAILOVER_IP"\
) # webapp status on cluster

actual_webapp_ip=$(\
  curl \
    --request GET \
    --url "https://api.cloudflare.com/client/v4/zones/$CLOUDFARE_ZONE_ID/dns_records/$CLFR_DNS_ID_OCI_INST_YO_COM" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $CLOUDFARE_API_TOKEN" | jq -r '.result.content'\
) ### cluster ip or failover ip

if [[ $webapp_cluster_status == "200" ]]; then
  echo "Cluster online - 200 - DNS re-configured"
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
  if [[ $webapp_failover_instance_status == "200" ]]; then
    echo "Failover instance online - 200 - DNS re-configured"
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
  else
    echo "Webapp Cluster Status: $webapp_cluster_status"
    echo "Cluster offline."
    echo "Webapp Failover Instance Status: $webapp_failover_instance_status"
    echo "Failover instance offline."
    echo "Website Down - Manual intervention required."
  fi
fi

# k get svc -n nginx-gateway -o json | jq -r '.items[0].status.loadBalancer.ingress[0].ip'
### */1 * * * * /bin/bash /home/ubuntu/repos-git/website-portifolio/usefull-scripts/webapp-failover-checker.sh "<CLUSTER_IP>" "<FAILOVER_IP>" > /var/log/webapp-failover-checker.log 2>&1
###