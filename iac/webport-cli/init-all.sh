#!/bin/sh
set -e

cd /app/terraform/prod && terraform init -input=false

cd /app/packer/prod\
 && packer init .\
 && source /app/packer/prod/wrapper.sh\

   cd /app/packer/prod/ansible\
    && source venv/bin/activate\
    && pip3 install -r requirements.txt --upgrade pip\
    && ansible-galaxy role install -r requirements.yml\
    && packer plugins install github.com/hashicorp/ansible

cd /app

source /root/.shrc
exec env ENV=/root/.shrc sh