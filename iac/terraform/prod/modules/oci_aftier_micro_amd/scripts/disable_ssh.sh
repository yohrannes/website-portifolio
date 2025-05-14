#!/bin/sh
terraform plan -out plan -target=module.oci_aftier_micro_amd.oci_core_security_list.public-security-list -var="disable_ssh_port=${1}"
