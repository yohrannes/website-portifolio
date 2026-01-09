#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -x

USER=ubuntu
HOME=/home/ubuntu

function wait-apt-lock () {
    local count=0
    while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do
        if [ $count -eq 0 ]; then
            echo "Waiting for apt lock to be released..."
        fi
        count=$((count + 1))
        if [ $count -gt 300 ]; then
            echo "ERROR: apt lock timeout"
            return 1
        fi
        sleep 1
    done
    return 0
}

function wait-for-network () {
    echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf > /dev/null
    echo "nameserver 1.0.0.1" | sudo tee -a /etc/resolv.conf > /dev/null
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf > /dev/null
    echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf > /dev/null
    echo "Waiting for network connectivity..."
    for i in {1..60}; do
        if ping -c 1 8.8.8.8 &> /dev/null; then
            echo "Network is up!"
            return 0
        fi
        echo "Attempt $i/60 - waiting for network..."
        sleep 2
    done
    echo "WARNING: Network failed to come up after 2 minutes"
    return 1
}

function wait-docker-ready () {
    local count=0
    echo "Waiting for Docker to be ready..."
    while ! sudo docker info >/dev/null 2>&1; do
        count=$((count + 1))
        if [ $count -gt 60 ]; then
            echo "ERROR: Docker failed to start"
            return 1
        fi
        sleep 1
    done
    echo "Docker is ready!"
    return 0
}

function install-docker-engine () {
    wait-apt-lock || return 1
    sudo apt-get update || return 1
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y || return 1
    sudo apt-get install -y ca-certificates curl || return 1
    sudo install -m 0755 -d /etc/apt/keyrings || return 1
    sudo curl -fsSL https://get.docker.com/ | sudo bash || return 1
    
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker $USER || return 1
    sudo mkdir -p $HOME/.docker || return 1
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R || return 1
    sudo chmod g+rwx "$HOME/.docker" -R || return 1
    
    sudo systemctl enable docker || return 1
    sudo systemctl enable containerd || return 1
    sudo systemctl start docker || return 1
    
    wait-docker-ready || return 1
    
    sudo docker buildx create --use --name multiarch-builder || return 1
    
    echo "Docker installed successfully"
    return 0
}

function allow-ports () {
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 22 -j ACCEPT || return 1
    sudo iptables -I INPUT 6 -p icmp --icmp-type echo-request -j ACCEPT || return 1
    sudo iptables -I INPUT 6 -p icmp --icmp-type echo-reply -j ACCEPT || return 1
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT || return 1
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT || return 1
    sudo netfilter-persistent save || return 1
    
    echo "Ports configured successfully"
    return 0
}

function install-usefull-packages () {
    wait-apt-lock || return 1
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nano net-tools wget curl jq htop traceroute mtr dnsutils tar tmux gzip python3-pip python3.12-venv || return 1
    sudo usermod -aG root $USER || return 1
    
    echo "Useful packages installed successfully"
    return 0
}

function install-gitlab-runner () {
    wait-apt-lock || return 1
    
    echo "Installing gitlab-runner..."
    
    sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" \
        -o /tmp/script.deb.sh || {
        echo "ERROR: Failed to download gitlab-runner script"
        return 1
    }
    
    sudo bash /tmp/script.deb.sh || return 1
    wait-apt-lock || return 1
    
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gitlab-runner || return 1
    
    sudo gitlab-runner --version || return 1
    sudo gitlab-runner start || return 1
    sudo gitlab-runner status || return 1
    
    echo "gitlab-runner installed successfully"
    return 0
}

function install-kubectl () {
    local kubectl_url="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    
    echo "Downloading kubectl from $kubectl_url"
    
    curl -fL "$kubectl_url" -o /tmp/kubectl || {
        echo "ERROR: Failed to download kubectl"
        return 1
    }
    
    chmod +x /tmp/kubectl || return 1
    sudo mv /tmp/kubectl /usr/local/bin/kubectl || return 1
    
    /usr/local/bin/kubectl version --client || return 1
    
    echo "kubectl installed successfully"
    return 0
}

function set-timezone () {
    sudo timedatectl set-timezone America/Sao_Paulo || return 1
    sudo timedatectl set-ntp true || return 1
    sudo timedatectl || return 1
    
    echo "Timezone configured successfully"
    return 0
}

wait-apt-lock || {
    echo "ERROR: System apt is locked at startup"
    exit 1
}

wait-for-network || {
    echo "WARNING: Network connectivity issues detected, continuing anyway..."
}

if [[ $1 == "install-docker" ]]; then
    install-docker-engine || exit 1
elif [[ $1 == "allow-ports" ]]; then
    allow-ports || exit 1
else
    install-docker-engine || {
        echo "ERROR: Docker installation failed"
        exit 1
    }
    
    wait-docker-ready || {
        echo "ERROR: Docker failed to start"
        exit 1
    }
    
    install-kubectl || {
        echo "ERROR: Kubectl installation failed"
        exit 1
    }
    
    install-gitlab-runner || {
        echo "ERROR: GitLab Runner installation failed"
        exit 1
    }
    
    allow-ports || {
        echo "ERROR: Port configuration failed"
        exit 1
    }
    
    install-usefull-packages || {
        echo "ERROR: Package installation failed"
        exit 1
    }
    
    set-timezone || {
        echo "ERROR: Timezone configuration failed"
        exit 1
    }
    
    echo "startup-script-finished"
fi