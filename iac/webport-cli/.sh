#!/bin/bash
docker build -t cloud-cli . -f webport-cli/Dockerfile

if [ "$1" == "pipe" ]; then
  INTERACTOR="-d"
  REMOVE=""
  COMMAND="sleep infinity"
else
  export HCP_CLIENT_SECRET=$(glab var get PACKER_WEBPORT_CLIENT_SECRET)
  export HCP_CLIENT_ID=$(glab var get PACKER_WEBPORT_CLIENT_ID)
  if [ -z "$HCP_CLIENT_ID" ] || [ -z "$HCP_CLIENT_SECRET" ]; then
      echo "Error: GitLab var not found"
      exit 1
  else
      echo "GitLab var found"
  fi
  INTERACTOR="-it"
  REMOVE="--rm"
fi

if $(docker ps -a --format '{{.Names}}' | grep -Eq "^cloud-cli\$"); then
  docker rm -f cloud-cli
fi

docker run $INTERACTOR --name cloud-cli $REMOVE\
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

## Coment this line bellow if you want to manage the infra just using docker.
sudo chown $USER: ../* && echo "Repo user permissions reloaded to current user."