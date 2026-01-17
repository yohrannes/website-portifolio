#!/bin/bash

IP=""
CLOUDFARE_ZONE_ID=""
CLFR_DNS_ID_OCI_INST_YO_COM=""
CLOUDFARE_API_TOKEN=""
PROD_WEBAPP_IP=""

last_status=""

while true; do
  current_status=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: yohrannes.com" "http://$IP")
  
  if [ "$current_status" != "$last_status" ]; then
    if [ "$current_status" = "200" ]; then
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
          "content": "'"$PROD_WEBAPP_IP"'",
          "type": "A"
        }' | jq '.'
    elif [ "$current_status" != "200" ]; then
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
          "content": "'"$PROD_WEBAPP_IP"'",
          "type": "A"
        }' | jq '.'
    fi
    
    last_status="$current_status"
  fi
  
  sleep 300
done