#!/bin/sh
set -e

cd /app/terraform/prod && terraform init\

cd /app/packer/prod\
 && packer init .\
 && source /app/packer/prod/wrapper.sh\

cd /app/packer/prod/ansible\
 && rm -rf venv\
 && python3 -m venv venv\
 && source venv/bin/activate\
 && pip3 install --break-system-packages ansible\
 && pip3 install --break-system-packages -r requirements.txt\
 && pip3 install -r requirements.txt --upgrade pip\
 && ansible-galaxy role install -r requirements.yml\
 && packer plugins install github.com/hashicorp/ansible \
 && export PATH=$PATH:/app/packer/prod/ansible/venv/bin \
 && ansible --version \
 && ansible-playbook --version

cd /app

exec env ENV=/root/.shrc sh
