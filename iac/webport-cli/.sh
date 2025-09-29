#!/bin/bash

export HCP_CLIENT_ID=$(glab var get PACKER_WEBPORT_CLIENT_ID)
export HCP_CLIENT_SECRET=$(glab var get PACKER_WEBPORT_CLIENT_SECRET)

if [ -z "$HCP_CLIENT_ID" ] || [ -z "$HCP_CLIENT_SECRET" ]; then
    echo "Error: GitLab var not found"
    exit 1
fi

echo "Glab var obtained with success"

docker build -t cloud-cli . -f webport-cli/Dockerfile


if [ "$1" == "pipe" ]; then
  INTERACTOR="-d"
  COMMAND="sleep infinity"
else
  INTERACTOR="-it"
  COMMAND=""
fi

docker run $INTERACTOR --name cloud-cli --rm\
  -e HCP_CLIENT_ID="$HCP_CLIENT_ID" \
  -e HCP_CLIENT_SECRET="$HCP_CLIENT_SECRET" \
  -v ~/.oci:/root/.oci \
  -v ~/.aws:/root/.aws \
  -v ~/.ssh:/root/.ssh \
  -v ~/.config/gcloud:/root/.config/gcloud \
  -v ~/.kube/config:/root/.kube/config \
  -v $PWD:/app \
  -v ~/.terraform.d/credentials.tfrc.json:/root/.terraform.d/credentials.tfrc.json \
  -e PACKER_PLUGIN_PATH=~/.packer.d/plugins \
  cloud-cli $COMMAND