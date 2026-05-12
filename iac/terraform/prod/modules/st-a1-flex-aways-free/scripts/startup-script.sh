#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -x

# Capture start time
SCRIPT_START_TIME=$(date +%s)

# Function to measure script duration
function measure_duration() {
    local start_time=$1
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local hours=$((duration / 3600))
    local minutes=$(((duration % 3600) / 60))
    local seconds=$((duration % 60))
    echo "${hours}h ${minutes}m ${seconds}s"
}

function remove-unnecessary-packages () {

    sudo systemctl stop modemmanager 2>/dev/null || true
    sudo systemctl disable modemmanager 2>/dev/null || true
    sudo apt-get purge -y modemmanager 2>/dev/null || true
    
    sudo systemctl stop pollinate 2>/dev/null || true
    sudo systemctl disable pollinate 2>/dev/null || true
    sudo apt-get purge -y pollinate 2>/dev/null || true
    
    sudo systemctl stop apport 2>/dev/null || true
    sudo systemctl disable apport 2>/dev/null || true
    sudo apt-get purge -y apport 2>/dev/null || true
    
    sudo systemctl stop lxd 2>/dev/null || true
    sudo systemctl disable lxd 2>/dev/null || true
    sudo apt-get purge -y lxd 2>/dev/null || true
    
    sudo apt-get autoremove -y 2>/dev/null || true
    
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

function update-repos-url () {
    sudo tee /etc/apt/sources.list.d/ubuntu.sources > /dev/null <<EOF
Types: deb
URIs: http://ports.ubuntu.com/ubuntu-ports/
Suites: noble noble-updates noble-backports
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://ports.ubuntu.com/ubuntu-ports/
Suites: noble-security
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF
wait-for-url "ports.ubuntu.com"
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update
wait-apt-lock
sudo apt-get upgrade -y
}




function install-docker-engine () {
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    
    wait-for-url "https://get.docker.com/"
    wait-for-url "https://download.docker.com/"
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
    sudo apt-get install -y mtr python3-pip python3.12-venv
    sudo usermod -aG root ubuntu
}

function install-gitlab-runner () {
    wait-for-url "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh"
    sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
    wait-apt-lock
    sudo apt-get update
    wait-apt-lock
    sudo apt-get install gitlab-runner -y
    sudo gitlab-runner -version
    sudo gitlab-runner status
    echo "gitlab-runner start"
    sudo gitlab-runner start
    sudo gitlab-runner status
}

function install-kubectl () {
    kversion=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    wait-for-url "https://dl.k8s.io/release/${kversion}/bin/linux/arm64/kubectl"
    curl -LO "https://dl.k8s.io/release/${kversion}/bin/linux/arm64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/kubectl
    /usr/local/bin/kubectl version --client
}

function set-timezone () {
    sudo timedatectl set-timezone America/Sao_Paulo
    sudo timedatectl set-ntp true
    sudo timedatectl    
}

function install-oci-cli () {
    sudo bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)" -- \
    --install-dir /opt/oci-cli \
    --exec-dir /usr/local/bin \
    --accept-all-defaults
}

allow-ports
set-timezone
update-repos-url
remove-unnecessary-packages
install-docker-engine
install-usefull-packages
install-kubectl
install-gitlab-runner

docker --version
kubectl version --client
gitlab-runner --version
timedatectl

### OCI Cloud-Init Cleanup ###
sudo rm -rf /var/lib/cloud/instances/*
sudo rm -rf /var/lib/cloud/instance
sudo rm -f /var/lib/cloud/instance-id
sudo rm -rf /var/lib/cloud/sem/
sudo rm -f /var/lib/cloud/instance-data.json
sudo rm -f /var/lib/cloud/instance-data-sensitive.json
sudo rm -f /var/lib/cloud/cloud-init-dhcp-*.json
sudo rm -f /var/lib/cloud/dhclient.*.json



# Leave this command bellow by least (used for pipeline).
echo "startup-script-finished" $(measure_duration $SCRIPT_START_TIME)
