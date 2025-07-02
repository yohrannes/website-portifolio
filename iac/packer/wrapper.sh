export OCI_CONFIG_FILE_PATH=~/.oci/packer/oci_config
export OCI_CONFIG_PROFILE=DEFAULT
cd ../../terraform/prod/
export PKR_VAR_compartment_ocid=$(terraform output -raw packer_compartment_ocid)
export PKR_VAR_availability_domain=$(terraform output -raw availability_domain)
export PKR_VAR_subnet_ocid=$(terraform output -raw packer_subnet_ocid)