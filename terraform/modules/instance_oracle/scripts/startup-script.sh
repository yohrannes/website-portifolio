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
sudo systemctl restart nginx
sudo systemctl enable nginx
}

function allow-ports () {
# 22 (SSH)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 22 -j ACCEPT
# ICMP (Ping)
sudo iptables -I INPUT 6 -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -I INPUT 6 -p icmp --icmp-type echo-reply -j ACCEPT

sudo netfilter-persistent save
}

function configure-website {
sudo apt-get install logrotate -y
sudo apt-get install cron -y

sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
sudo netfilter-persistent save

sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

sudo sed -i '/http {/a \    log_format upstream_time '"'"'$remote_addr - $remote_user [$time_local] '"'"' \
                             '"'"'"\$request" $status $body_bytes_sent '"'"' \
                             '"'"'"\$http_referer" "\$http_user_agent" '"'"' \
                             '"'"'rt=$request_time uct="$upstream_connect_time" '"'"' \
                             '"'"'uht="$upstream_header_time" urt="$upstream_response_time"'"'"';' /etc/nginx/nginx.conf

sudo tee /etc/nginx/sites-available/oracle-instance.yohrannes.com <<EOF
server {
    listen 80;
    server_name oracle-instance.yohrannes.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    access_log /var/log/nginx/oracle-instance.yohrannes.com-access.log upstream_time;
    error_log /var/log/nginx/oracle-instance.yohrannes.com-error.log warn;
}
EOF

sudo ln -s /etc/nginx/sites-available/oracle-instance.yohrannes.com /etc/nginx/sites-enabled/
sudo systemctl restart nginx

sudo docker run -d yohrannes/website-portifolio -p 5000:5000
}

if [[ $1 == "install-nginx" ]]; then
    install-nginx
elif [[ $1 == "install-docker" ]]; then
    install-docker-engine
else
    install-nginx
    install-docker-engine
    allow-ports
    configure-website

    # Leave this command bellow by least (used in pipeline)
    echo "startup-script-finished"
fi
