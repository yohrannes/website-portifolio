#!/bin/bash
current_version=$(curl -s "https://registry.hub.docker.com/v2/repositories/yohrannes/website-portifolio/tags?page_size=100" | jq -r '.results[].name' | grep -v "latest" | head -n 1 | sed 's/^v//')
first=$(echo "$current_version" | cut -d. -f1)
second=$(echo "$current_version" | cut -d. -f2)
third=$(echo "$current_version" | cut -d. -f3)
third=$((third + 1))

if [ "$third" -eq 10 ]; then
  third=0
  second=$((second + 1))
fi

if [ "$second" -eq 10 ]; then
  second=0
  first=$((first + 1))
fi

new_version="$first.$second.$third"
echo "$new_version"