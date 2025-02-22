#!/bin/bash
docker run -it \
  -v ~/.oci:/root/.oci \
  -v ~/.aws:/root/.aws \
  -v ~/.ssh:/root/.ssh \
  -v ~/.gcp:/root/.gcp \
  -v $PWD:/app \
  -v $PWD/.shrc:/root/.shrc \
  -w /app \
  --entrypoint "" hashicorp/terraform:latest sh -c \
  "source /root/.shrc && terraform init -reconfigure && ENV=/root/.shrc sh"
