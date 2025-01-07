#!/bin/bash
current_version=$(curl -s "https://registry.hub.docker.com/v2/repositories/yohrannes/website-portifolio/tags?page_size=100" | jq -r '.results[].name' | grep -v "latest" | head -n 1 | sed 's/^v//')
major=$(echo "$current_version" | cut -d. -f1)
minor=$(echo "$current_version" | cut -d. -f2)
minor=$((minor + 1))
if [ "$minor" -eq 10 ]; then
  minor=0
  major=$((major + 1))
fi
new_version="$major.$minor"
echo "$new_version"