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
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo systemctl start docker
}

function install-nginx () {
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y nginx
sudo tee /etc/nginx/sites-available/default <<EOF
server {
listen 80;
server_name _;

location / {
    proxy_pass http://localhost:5000;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
}
}
EOF
sudo systemctl restart nginx
sudo systemctl enable nginx
}

function allow-ports () {
# 80 (HTTP)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
# 443 (HTTPS)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
# 22 (SSH)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 22 -j ACCEPT
# ICMP (Ping)
sudo iptables -I INPUT 6 -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -I INPUT 6 -p icmp --icmp-type echo-reply -j ACCEPT

sudo netfilter-persistent save
}

if [[ $1 == "install-nginx" ]]; then
    install-nginx
elif [[ $1 == "install-docker" ]]; then
    install-docker-engine
else
    install-nginx
    install-docker-engine
    allow-ports

    # Leave this command bellow by least (used in pipeline)
    echo "startup-script-finished"
fi
