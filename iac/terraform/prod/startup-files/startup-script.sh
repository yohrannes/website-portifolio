#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -x

function install-docker-engine () {
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install -y ca-certificates curl qemu binfmt-support qemu-user-static
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://get.docker.com/ | sudo bash
    sudo groupadd docker || true
    sudo usermod -aG docker $USER
    sudo mkdir -p $HOME/.docker
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
    sudo systemctl enable docker
    sudo systemctl start docker
    if command -v docker >/dev/null 2>&1; then
        docker buildx create --use --name multiarch-builder
    fi
}

function allow-ports () {
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 22 -j ACCEPT
    sudo iptables -I INPUT 6 -p icmp --icmp-type echo-request -j ACCEPT
    sudo iptables -I INPUT 6 -p icmp --icmp-type echo-reply -j ACCEPT
    sudo netfilter-persistent save
}

function install-usefull-packages () {
    sudo apt-get install -y nano net-tools wget curl jq htop traceroute mtr dnsutils tmux gzip tar
}

function allow-swap-memory () {
    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
}

function install-gitlab-runner () {
    sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
    sudo apt-get install gitlab-runner -y
    sudo gitlab-runner -version
    sudo gitlab-runner status
    echo "gitlab-runner start"
    sudo gitlab-runner start
    sudo gitlab-runner status
}

function install-kubectl () {
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/kubectl
    /usr/local/bin/kubectl version --client
}

function install-oci-cli () {
    sudo bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" -- \
    --install-dir /opt/oci-cli \
    --exec-dir /usr/local/bin \
    --accept-all-defaults
}

function install-helm () {
    sudo apt-get install curl gpg apt-transport-https --yes
    curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm
}

function install-docker-scout () {
    while ! docker info > /dev/null 2>&1; do
        sleep 2
    done
    mkdir -p /root/.docker/cli-plugins
    curl -fsSL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh
    sh install-scout.sh
}

if [[ $1 == "install-docker" ]]; then
    install-docker-engine
else
    install-docker-engine
    allow-ports
    install-usefull-packages
    allow-swap-memory
    install-gitlab-runner
    install-kubectl
    install-oci-cli
    install-helm
    install-docker-scout

    # Leave this command bellow by least (used for pipeline checks)
    echo "startup-script-finished"
fi
