#!/bin/bash
docker build -t cloud-cli . -f webport-cli/Dockerfile

### check --build-arg HOME="$HOME" maybe can be usable.

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
  -e LOCAL_UID=$(id -u) \
  -e LOCAL_GID=$(id -g) \
  -e HCP_CLIENT_ID="$HCP_CLIENT_ID" \
  -e HCP_CLIENT_SECRET="$HCP_CLIENT_SECRET" \
  -v ~/.oci:/home/clouduser/.oci \
  -v ~/.ssh:/home/clouduser/.ssh \
  -v ~/.config/gcloud:/home/clouduser/.config/gcloud \
  -v ~/.kube/config:/home/clouduser/.kube/config \
  -v $PWD:/app \
  -v ~/.terraform.d/credentials.tfrc.json:/home/clouduser/.terraform.d/credentials.tfrc.json \
  -e PACKER_PLUGIN_PATH=/home/clouduser/.packer.d/plugins \
cloud-cli $COMMAND

## Coment this line bellow if you want to manage the infra just using docker.
#sudo chown $USER: ../* && echo "Repo user permissions reloaded to current user."
