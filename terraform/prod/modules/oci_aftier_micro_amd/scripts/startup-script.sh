#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -x

function install-docker-engine () {
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo curl -fsSL https://get.docker.com/ | sudo bash
sudo newgrp docker
sudo groupadd docker
sudo usermod -aG docker $USER
sudo mkdir $HOME/.docker
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
sudo systemctl enable docker
sudo systemctl start docker
}

function allow-ports () {
# 22 (SSH)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 22 -j ACCEPT
# ICMP (Ping)
sudo iptables -I INPUT 6 -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -I INPUT 6 -p icmp --icmp-type echo-reply -j ACCEPT
# HTTP + HTTPS
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT

sudo netfilter-persistent save
}

function install-usefull-packages () {
    sudo apt-get install -y nano net-tools wget curl jq htop traceroute mtr dnsutils tmux fail2ban
}

if [[ $1 == "install-docker" ]]; then
    install-docker-engine
elif [[ $1 == "allow-ports" ]]; then
    allow-ports
else
    install-docker-engine
    allow-ports
    install-usefull-packages
    # Leave this command bellow by least (used for pipeline checks).
    echo "startup-script-finished"
fi
