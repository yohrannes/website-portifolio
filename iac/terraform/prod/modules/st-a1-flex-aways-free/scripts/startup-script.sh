#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -e -x

USER=ubuntu
HOME=/home/ubuntu

function kill-blocking-processes () {
    echo "=== Killing blocking processes ==="
    
    sudo systemctl stop unattended-upgrades 2>/dev/null || true
    sudo systemctl disable unattended-upgrades 2>/dev/null || true
    sudo pkill -9 -f unattended-upgrade 2>/dev/null || true
    sudo pkill -9 -f apt-daily 2>/dev/null || true
    sudo pkill -9 -f apt-daily-upgrade 2>/dev/null || true
    
    sleep 2
    
    for i in {1..5}; do
        if ! pgrep -f 'unattended-upgrade|apt-daily' > /dev/null; then
            echo "Blocking processes killed successfully"
            return 0
        fi
        echo "Waiting for processes to die... (attempt $i/5)"
        sleep 1
    done
    
    return 0
}

function wait-for-lock () {
    local lock_file=$1
    local timeout=10
    local elapsed=0
    
    while [ -f "$lock_file" ] && [ $elapsed -lt $timeout ]; do
        sleep 0.5
        elapsed=$((elapsed + 1))
    done
}

function apt-wait-completion () {
    local timeout=30
    local elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        if ! pgrep -f 'apt-get|apt |dpkg' > /dev/null 2>&1; then
            if ! sudo fuser /var/lib/dpkg/lock 2>/dev/null | grep -q .; then
                sleep 1
                return 0
            fi
        fi
        
        sleep 1
        elapsed=$((elapsed + 1))
    done
    
    echo "WARNING: apt still busy after ${timeout}s, forcing..."
    kill-blocking-processes
    sleep 2
    
    return 0
}

function install-docker-engine () {
    apt-wait-completion
    
    echo "=== Updating package lists ==="
    sudo DEBIAN_FRONTEND=noninteractive apt-get update
    
    apt-wait-completion
    
    echo "=== Upgrading packages ==="
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
    
    apt-wait-completion
    
    echo "=== Installing ca-certificates and curl ==="
    sudo apt-get install -y ca-certificates curl
    
    apt-wait-completion
    
    sudo install -m 0755 -d /etc/apt/keyrings
    
    echo "=== Installing Docker ==="
    sudo curl -fsSL https://get.docker.com/ | sudo bash
    
    sleep 3
    
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker $USER
    sudo mkdir -p $HOME/.docker
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
    
    sudo systemctl enable docker
    sudo systemctl enable containerd
    sudo systemctl start docker
    
    sleep 10
    
    echo "Docker installation completed"
}

function allow-ports () {
    echo "=== Configuring firewall ports ==="
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 22 -j ACCEPT
    sudo iptables -I INPUT 6 -p icmp --icmp-type echo-request -j ACCEPT
    sudo iptables -I INPUT 6 -p icmp --icmp-type echo-reply -j ACCEPT
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
    sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
    sudo netfilter-persistent save
    
    echo "Firewall configuration completed"
}

function install-usefull-packages () {
    apt-wait-completion
    
    echo "=== Installing useful packages ==="
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nano net-tools wget curl jq htop traceroute mtr dnsutils tar tmux gzip python3-pip python3.12-venv
    
    apt-wait-completion
    
    sudo usermod -aG root $USER
    
    echo "Useful packages installation completed"
}

function install-gitlab-runner () {
    apt-wait-completion
    
    echo "=== Setting up GitLab Runner repository ==="
    sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
    
    apt-wait-completion
    sleep 5
    
    echo "=== Installing gitlab-runner ==="
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gitlab-runner
    
    apt-wait-completion
    
    sudo gitlab-runner --version
    
    sleep 2
    
    sudo gitlab-runner start
    
    sleep 3
    
    sudo gitlab-runner status
    
    echo "GitLab Runner installation completed"
}

function install-kubectl () {
    echo "=== Installing kubectl ==="
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
    
    sleep 1
    
    /usr/local/bin/kubectl version --client
    
    echo "kubectl installation completed"
}

function set-timezone () {
    echo "=== Setting timezone ==="
    sudo timedatectl set-timezone America/Sao_Paulo
    sudo timedatectl set-ntp true
    sudo timedatectl
    
    echo "Timezone configuration completed"
}

echo "=== Starting startup script ==="
echo "Script PID: $$"

kill-blocking-processes

set-timezone
allow-ports
install-usefull-packages
install-docker-engine
install-gitlab-runner
install-kubectl

echo "=== startup-script-finished ==="