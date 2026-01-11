#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -x

function wait-apt-lock () {
    local timeout=300
    local elapsed=0
    
    echo "Waiting for apt lock to be released..."
    
    while [ $elapsed -lt $timeout ]; do
        if ! sudo fuser /var/lib/apt/lists/lock 2>/dev/null; then
            echo "apt lock released!"
            return 0
        fi
        
        sleep 2
        elapsed=$((elapsed + 2))
    done
    
    echo "WARNING: apt still locked after ${timeout}s"
    return 1
}

function wait-for-url () {
    local url=$1
    local timeout=300
    local elapsed=0
    
    echo "Checking if $url is online..."
    
    while [ $elapsed -lt $timeout ]; do
        if curl -fsSL --connect-timeout 5 "$url" > /dev/null 2>&1; then
            echo "URL is online!"
            return 0
        fi
        
        echo "URL offline, retrying... (${elapsed}s)"
        sleep 5
        elapsed=$((elapsed + 5))
    done
    
    echo "WARNING: URL still offline after ${timeout}s, continuing anyway..."
    return 1
}

function install-docker-engine () {
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    
    wait-for-url "https://get.docker.com/"
    wait-apt-lock
    sudo curl -fsSL https://get.docker.com/ | sudo bash

    sudo usermod -aG docker root
    sudo mkdir /home/ubuntu/.docker
    sudo chown ubuntu:ubuntu /home/ubuntu/.docker -R
    sudo chmod g+rwx /home/ubuntu/.docker -R
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
}

function install-usefull-packages () {
    sudo apt-get install -y nano net-tools wget curl jq htop traceroute dnsutils tar gzip
    echo "_____________________________________________________________________________"
    echo "_____________________________________________________________________________"
    echo "_____________________________________________________________________________"
    echo "_____________________________________________________________________________"
    sudo apt-get install -y mtr python3-pip python3.12-venv
    sudo usermod -aG root ubuntu
}

function install-gitlab-runner () {
    wait-for-url "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh"
    sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
    sudo apt-get install gitlab-runner -y
    sudo gitlab-runner -version
    sudo gitlab-runner status
    echo "gitlab-runner start"
    sudo gitlab-runner start
    sudo gitlab-runner status
}

function install-kubectl () {
    wait-for-url "https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
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

install-docker-engine
allow-ports
install-usefull-packages
set-timezone
install-kubectl
install-gitlab-runner

docker --version
kubectl version --client --short
gitlab-runner --version
timedatectl

# Leave this command bellow by least (used for pipeline).
echo "startup-script-finished"
