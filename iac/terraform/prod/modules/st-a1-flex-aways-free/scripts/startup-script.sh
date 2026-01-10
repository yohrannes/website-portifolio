#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -e -x
 
USER=ubuntu
HOME=/home/ubuntu

function wait-for-apt-complete() {
    local timeout=600
    local elapsed=0
    
    echo "Waiting for system to be ready..."
    
    while [ $elapsed -lt $timeout ]; do
        if ! sudo fuser /var/lib/apt/lists/lock 2>/dev/null; then
            if ! sudo fuser /var/lib/dpkg/lock 2>/dev/null; then
                if ! sudo fuser /var/cache/apt/archives/lock 2>/dev/null; then
                    if ! pgrep -f "apt-get|apt|dpkg|unattended|needrestart" >/dev/null 2>&1; then
                        sleep 3
                        echo "System ready!"
                        return 0
                    fi
                fi
            fi
        fi
        
        if [ $((elapsed % 30)) -eq 0 ] && [ $elapsed -gt 0 ]; then
            echo "Still waiting... (${elapsed}s)"
        fi
        
        sleep 1
        elapsed=$((elapsed + 1))
    done
    
    echo "WARNING: Timeout waiting for apt, continuing anyway..."
    return 0
}

function install-docker-engine () {
    wait-for-apt-complete || return 1
    sudo apt-get update
    yes | sudo apt-get upgrade
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://get.docker.com/ | sudo bash
    sudo usermod -aG docker $USER
    sudo mkdir -p $HOME/.docker
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
    sudo systemctl enable docker
    sudo systemctl enable containerd
    sudo systemctl start docker
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
    wait-for-apt-complete || return 1
    sudo apt-get update
    sudo apt-get install -y nano net-tools wget curl jq htop dnsutils tar tmux gzip build-essential mtr-tiny
}

function install-gitlab-runner () {
    wait-for-apt-complete || return 1
    
    sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" -o /tmp/script.deb.sh || return 1
    sudo bash /tmp/script.deb.sh
    
    wait-for-apt-complete || return 1
    sudo apt-get install -y gitlab-runner
    
    sudo gitlab-runner --version
    sudo gitlab-runner start
    sudo gitlab-runner status
}

function install-kubectl () {
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/kubectl
    /usr/local/bin/kubectl version --client
}

function set-timezone () {
    sudo timedatectl set-timezone America/Sao_Paulo
    sudo timedatectl set-ntp true
    sudo timedatectl    
}

wait-for-apt-complete || {
    echo "ERROR: System apt is locked at startup"
    exit 1
}

set-timezone
allow-ports
install-usefull-packages
wait-for-apt-complete
install-docker-engine
wait-for-apt-complete
install-gitlab-runner
wait-for-apt-complete
install-kubectl

echo "startup-script-finished"