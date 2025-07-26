#!/bin/bash

docker build -t cloud-cli . -f webport-cli/Dockerfile

docker run -it --name cloud-cli --rm\
  -v ~/.oci:/root/.oci \
  -v ~/.aws:/root/.aws \
  -v ~/.ssh:/root/.ssh \
  -v ~/.gcp:/root/.gcp \
  -v ~/.config/gcloud \
  -v ~/.kube/config:/root/.kube/config \
  -v $PWD:/app \
  -v ~/.terraform.d/credentials.tfrc.json:/root/.terraform.d/credentials.tfrc.json \
  -e PACKER_PLUGIN_PATH=~/.packer.d/plugins \
  cloud-cli

if [ $1 == "pipe" ]; then
docker run -d --name cloud-cli --rm\
  -v ~/.oci:/root/.oci \
  -v ~/.aws:/root/.aws \
  -v ~/.ssh:/root/.ssh \
  -v ~/.gcp:/root/.gcp \
  -v ~/.config/gcloud \
  -v ~/.kube/config:/root/.kube/config \
  -v $PWD:/app \
  -v ~/.terraform.d/credentials.tfrc.json:/root/.terraform.d/credentials.tfrc.json \
  -e PACKER_PLUGIN_PATH=~/.packer.d/plugins \
  cloud-cli sleep infinity
fi