#!/bin/sh
set -e

cd /app/terraform/prod && terraform init -reconfigure -input=false
cd /app/packer/prod && packer init .
cd /app

source /root/.shrc
exec env ENV=/root/.shrc sh