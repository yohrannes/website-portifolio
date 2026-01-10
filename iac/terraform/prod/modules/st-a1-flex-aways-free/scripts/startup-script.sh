#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -e -x

USER=ubuntu
HOME=/home/ubuntu

function install-docker-engine () {
    sudo apt-get -o DPkg::Lock::Timeout=300 update
    yes | sudo apt-get -o DPkg::Lock::Timeout=300 upgrade
    sudo apt-get -o DPkg::Lock::Timeout=300 install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://get.docker.com/ | sudo bash
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker $USER
    sudo mkdir -p $HOME/.docker
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
    sudo systemctl enable docker
    sudo systemctl enable containerd
    sudo systemctl start docker
    sleep 5
}

function allow-ports () {
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 22 -j ACCEPT
    sudo iptables -I INPUT 6 -p icmp --icmp-type echo-request -j ACCEPT
    sudo iptables -I INPUT 6 -p icmp --icmp-type echo-reply -j ACCEPT
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
    sudo netfilter-persistent save
}

function install-usefull-packages () {
    sudo apt-get -o DPkg::Lock::Timeout=300 install -y nano net-tools wget curl jq htop traceroute mtr dnsutils tar tmux gzip python3-pip python3.12-venv
    sudo usermod -aG root $USER
}

function install-gitlab-runner () {
    sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
    sudo apt-get -o DPkg::Lock::Timeout=300 install gitlab-runner -y
    sudo gitlab-runner -version
    sudo gitlab-runner status
    echo "gitlab-runner start"
    sudo gitlab-runner start
    sudo gitlab-runner status
}

function install-kubectl () {
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
    /usr/local/bin/kubectl version --client
}

function set-timezone () {
    sudo timedatectl set-timezone America/Sao_Paulo
    sudo timedatectl set-ntp true
    sudo timedatectl    
}

set-timezone
allow-ports
install-usefull-packages
install-docker-engine
install-gitlab-runner
install-kubectl

echo "startup-script-finished"