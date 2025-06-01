#!/bin/bash
#docker run -it \
#  -v ~/.oci:/root/.oci \
#  -v ~/.aws:/root/.aws \
#  -v ~/.ssh:/root/.ssh \
#  -v ~/.gcp:/root/.gcp \
#  -v ~/.kube/config:/root/.kube/config \
#  -v $PWD:/app \
#  -v $PWD/.shrc:/root/.shrc \
#  -w /app \
#  --entrypoint "" hashicorp/terraform:latest sh -c \
#  "source /root/.shrc && terraform init -reconfigure && apk add oci-cli --quiet && ENV=/root/.shrc sh"

docker build -t tf-container . -f tfinu/Dockerfile

docker run -it --rm\
  -v ~/.oci:/root/.oci \
  -v ~/.aws:/root/.aws \
  -v ~/.ssh:/root/.ssh \
  -v ~/.gcp:/root/.gcp \
  -v ~/.config/gcloud \
  -v ~/.kube/config:/root/.kube/config \
  -v $PWD:/app \
  tf-container
