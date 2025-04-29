#!/bin/bash
current_version=$(echo "$1")
major=$(echo "$current_version" | cut -d. -f1)
minor=$(echo "$current_version" | cut -d. -f2)
patch=$(echo "$current_version" | cut -d. -f3)

if [ "$2" == "patch" ]; then
  patch=$((patch + 1))
elif [ "$2" == "minor" ]; then
  minor=$((minor + 1))
  patch=0
elif [ "$2" == "major" ]; then
  major=$((major + 1))
  minor=0
  patch=0
else
  echo "Invalid argument. Use 'patch', 'minor', or 'major'."
  exit 1
fi

new_version="$major.$minor.$patch"
echo "$new_version"