#!/bin/bash
current_version=$(curl -s "https://registry.hub.docker.com/v2/repositories/$1/tags?page_size=100" | jq -r '.results[].name' | grep -v "latest" | head -n 1 | sed 's/^v//'| sed 's/-.*//')
echo "$current_version"