#!/bin/sh
set -e

if [ "$(id -u)" -eq 0 ]; then
    GROUP_ID=${LOCAL_GID:-1000}
    USER_ID=${LOCAL_UID:-1000}

    groupmod -g $GROUP_ID clouduser 2>/dev/null || true
    usermod -u $USER_ID clouduser 2>/dev/null || true

    echo "nameserver 8.8.8.8" > /etc/resolv.conf
    echo "nameserver 1.1.1.1" >> /etc/resolv.conf

    chown -R clouduser:clouduser /home/clouduser
    chown -R clouduser:clouduser /app

    mkdir -p /home/clouduser/.config/gcloud
    mkdir -p /home/clouduser/.config/gcloud/logs
    chmod 700 /home/clouduser/.config/gcloud/logs
    chown -R clouduser:clouduser /home/clouduser/.config

    exec su clouduser -s /bin/sh "$0"
fi

cd /app/terraform/prod && terraform init -upgrade

cd /app/packer/prod && packer init .

cd /app/packer/prod/ansible
rm -rf venv
python3 -m venv venv
. venv/bin/activate
pip3 install --quiet ansible
pip3 install --quiet -r requirements.txt
pip3 install --quiet -r requirements.txt --upgrade pip
ansible-galaxy role install -r requirements.yml
packer plugins install github.com/hashicorp/ansible 2>/dev/null || true
export PATH=$PATH:/app/packer/prod/ansible/venv/bin

ansible --version
ansible-playbook --version

cd /app

exec env ENV=/home/clouduser/.shrc sh
