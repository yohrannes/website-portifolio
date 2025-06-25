#!/bin/bash

# Script to export OCI config values as Packer environment variables
# Usage: source ./wrapper-oci-auth.sh [PROFILE_NAME]

# Check if script is being sourced (not executed)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "❌ Error: This script must be sourced to export variables to your current shell."
    echo "Usage: source ./wrapper-oci-auth.sh [PROFILE_NAME]"
    echo "   or: . ./wrapper-oci-auth.sh [PROFILE_NAME]"
    exit 1
fi

CONFIG_FILE="$HOME/.oci/config"
PROFILE="${1:-DEFAULT}"  # Use DEFAULT profile or specify as first argument

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Error: OCI config file not found at $CONFIG_FILE"
    return 1
fi

echo "📋 Reading OCI config from: $CONFIG_FILE"
echo "👤 Using profile: $PROFILE"
echo "----------------------------------------"

# Function to extract value from config file
get_config_value() {
    local key="$1"
    local profile="$2"
    
    # Use awk to parse the INI-style config file
    awk -v profile="[$profile]" -v key="$key" '
        $0 == profile { in_section = 1; next }
        /^\[/ && in_section { in_section = 0 }
        in_section && $0 ~ "^" key "=" {
            sub("^" key "=", "")
            gsub(/^[ \t]+|[ \t]+$/, "")  # trim whitespace
            print
            exit
        }
    ' "$CONFIG_FILE"
}

# Extract values from OCI config
TENANCY_OCID=$(get_config_value "tenancy" "$PROFILE")
USER_OCID=$(get_config_value "user" "$PROFILE")
FINGERPRINT=$(get_config_value "fingerprint" "$PROFILE")
KEY_FILE=$(get_config_value "key_file" "$PROFILE")
REGION=$(get_config_value "region" "$PROFILE")
COMPARTMENT_OCID=$(get_config_value "compartment_id" "$PROFILE")

# Handle key_file path (expand ~ if present)
if [[ "$KEY_FILE" =~ ^~/ ]]; then
    KEY_FILE="${KEY_FILE/#~/$HOME}"
elif [[ "$KEY_FILE" =~ ^\~/ ]]; then
    KEY_FILE="${KEY_FILE/#\~/$HOME}"
fi

# Also handle if the path doesn't have expansion but starts with ~
KEY_FILE=$(eval echo "$KEY_FILE")

# Check if required values are found
if [[ -z "$TENANCY_OCID" || -z "$USER_OCID" || -z "$FINGERPRINT" || -z "$KEY_FILE" || -z "$REGION" ]]; then
    echo "❌ Error: Missing required values in OCI config file for profile '$PROFILE'"
    echo "Required: tenancy, user, fingerprint, key_file, region"
    return 1
fi

# Export as Packer environment variables (using PKR_VAR_ prefix for HCL2)
export PKR_VAR_tenancy_ocid="$TENANCY_OCID"
export PKR_VAR_user_ocid="$USER_OCID"
export PKR_VAR_fingerprint="$FINGERPRINT"
export PKR_VAR_private_key_path="$KEY_FILE"
export PKR_VAR_region="$REGION"

TF_OUTPUT_DIR="../../terraform/prod"

if [[ -d "$TF_OUTPUT_DIR" ]]; then
    TF_COMPARTMENT_OCID=$(cd "$TF_OUTPUT_DIR" && terraform output -raw oci_packer_compartment_ocid 2>/dev/null)
    TF_SUBNET_OCID=$(cd "$TF_OUTPUT_DIR" && terraform output -raw oci_packer_subnet_ocid 2>/dev/null)
    if [[ -n "$TF_COMPARTMENT_OCID" ]]; then
        export PKR_VAR_compartment_ocid="$TF_COMPARTMENT_OCID"
    fi
    if [[ -n "$TF_SUBNET_OCID" ]]; then
        export PKR_VAR_subnet_ocid="$TF_SUBNET_OCID"
    fi
fi

echo "✅ Exported Packer environment variables:"
echo "   PKR_VAR_tenancy_ocid='$PKR_VAR_tenancy_ocid'"
echo "   PKR_VAR_user_ocid='$PKR_VAR_user_ocid'"
echo "   PKR_VAR_fingerprint='$PKR_VAR_fingerprint'"
echo "   PKR_VAR_private_key_path='$PKR_VAR_private_key_path'"
echo "   PKR_VAR_region='$PKR_VAR_region'"

if [[ -n "$PKR_VAR_compartment_ocid" ]]; then
    echo "   PKR_VAR_compartment_ocid='$PKR_VAR_compartment_ocid'"
else
    echo "⚠️  Note: compartment_ocid not found in config or Terraform outputs"
fi
if [[ -n "$PKR_VAR_subnet_ocid" ]]; then
    echo "   PKR_VAR_subnet_ocid='$PKR_VAR_subnet_ocid'"
else
    echo "⚠️  Note: subnet_ocid not found in Terraform outputs"
fi

echo "🚀 Ready to run: packer validate ."
