#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -x

USER=ubuntu
HOME=/home/ubuntu

function install-docker-engine () {
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://get.docker.com/ | sudo bash
    sudo newgrp docker
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo mkdir $HOME/.docker
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
    sudo systemctl enable docker
    sudo systemctl enable containerd
    sudo systemctl start docker
#    docker buildx create --use --name multiarch-builder
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
    sudo apt-get install -y nano net-tools wget curl jq htop traceroute mtr dnsutils
    sudo usermod -aG root $USER
}

function allow-swap-memory () {
    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
}

function set-timezone () {
    sudo timedatectl set-timezone America/Sao_Paulo
    sudo timedatectl set-ntp true
    sudo timedatectl    
}

if [[ $1 == "install-docker" ]]; then
    install-docker-engine
elif [[ $1 == "allow-ports" ]]; then
    allow-ports
else
    install-docker-engine
    allow-ports
    install-usefull-packages
    allow-swap-memory
    set-timezone
    # Leave this command bellow by least (used for pipeline).
    echo "startup-script-finished"
fi
