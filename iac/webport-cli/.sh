#!/bin/bash
spinner() {
  local pid=$1
  local msg="${2:-Building image...}"
  local spin=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  tput civis 2>/dev/null || true
  trap "tput cnorm 2>/dev/null; kill -TERM $pid 2>/dev/null; exit 1" INT TERM
  while kill -0 "$pid" 2>/dev/null; do
    for s in "${spin[@]}"; do
      printf "\r\033[K\033[36m%s\033[0m %s" "$s" "$msg"
      sleep 0.08
      if ! kill -0 "$pid" 2>/dev/null; then break; fi
    done
  done
  trap - INT TERM
  tput cnorm 2>/dev/null || true
}

BUILD_LOG=$(mktemp)
docker build -q -t cloud-cli . -f webport-cli/Dockerfile > "$BUILD_LOG" 2>&1 &
BUILD_PID=$!

spinner $BUILD_PID "Building cloud-cli image..."
wait $BUILD_PID
BUILD_STATUS=$?
if [ $BUILD_STATUS -eq 0 ]; then
  printf "\r\033[K\033[32m✔\033[0m cloud-cli image built successfully!\n"
  rm -f "$BUILD_LOG"
else
  printf "\r\033[K\033[31m✖\033[0m Failed to build Docker image (exit code: %d):\n" "$BUILD_STATUS"
  cat "$BUILD_LOG"
  rm -f "$BUILD_LOG"
  exit $BUILD_STATUS
fi

if [ "$1" == "pipe" ]; then
  INTERACTOR="-d"
  REMOVE=""
  COMMAND="sleep infinity"
else
  INTERACTOR="-it"
  REMOVE="--rm"
fi

if $(docker ps -a --format '{{.Names}}' | grep -Eq "^cloud-cli\$"); then
  docker rm -f cloud-cli
fi

docker run $INTERACTOR --name cloud-cli $REMOVE\
  --env-file $PWD/../.env \
  -e LOCAL_UID=$(id -u) \
  -e LOCAL_GID=$(id -g) \
  -v ~/.oci:/home/clouduser/.oci \
  -v ~/.ssh:/home/clouduser/.ssh \
  -v ~/.config/gcloud:/home/clouduser/.config/gcloud \
  -v ~/.kube/config:/home/clouduser/.kube/config \
  -v $PWD:/app \
  -v $PWD/../.env:/home/clouduser/.env \
  -v ~/.terraform.d/credentials.tfrc.json:/home/clouduser/.terraform.d/credentials.tfrc.json \
  -e PACKER_PLUGIN_PATH=/home/clouduser/.packer.d/plugins \
cloud-cli $COMMAND

## Coment this line bellow if you want to manage the infra just using docker.
#sudo chown $USER: ../* && echo "Repo user permissions reloaded to current user."
