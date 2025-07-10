#!/bin/sh
cd ../../terraform/prod/
export PKR_VAR_compartment_ocid=$(terraform output -raw packer_compartment_ocid)
export PKR_VAR_subnet_ocid=$(terraform output -raw packer_subnet_ocid)
#export PKR_VAR_image_name=$(terraform output -raw packer_image_name)
cd -
