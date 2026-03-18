#!/bin/sh

## if kubeconfig not exist do this

## nano ~/.kube/config

## paste this ...

## apiVersion: v1
## kind: Config
## clusters:
## users:
## contexts:

## then run this script

COMPARTMENT_ID=$(terraform state show module.webapp.module.compartment.oci_identity_compartment.main | grep "id" | awk '{print $3}' | tr -d '"'| grep compartment)

echo "Compartment ID: $COMPARTMENT_ID"

CLUSTER_ID=$(oci ce cluster list --compartment-id "$COMPARTMENT_ID" --query "data[0].id" --raw-output)

echo "Cluster ID: $CLUSTER_ID"

PROFILE=DEFAULT

echo "oci ce cluster create-kubeconfig --cluster-id $CLUSTER_ID --file ~/.kube/config --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT --profile $PROFILE"

oci ce cluster create-kubeconfig --cluster-id $CLUSTER_ID --file ~/.kube/config --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT --profile DEFAULT

cat ~/.kube/config