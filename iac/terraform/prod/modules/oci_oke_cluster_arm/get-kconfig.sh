#!/bin/sh
COMPARTMENT_ID=$(terraform output oci_oke_cluster_arm_compartment_id | sed 's/"//g')
echo "Compartment ID: $COMPARTMENT_ID"
CLUSTER_ID=$(oci ce cluster list --compartment-id "$COMPARTMENT_ID" --query "data[0].id" --raw-output)
echo "Cluster ID: $CLUSTER_ID"
PROFILE=DEFAULT

echo "oci ce cluster create-kubeconfig --cluster-id $CLUSTER_ID --file ~/.kube/config --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT --profile $PROFILE"
oci ce cluster create-kubeconfig --cluster-id $CLUSTER_ID --file ~/.kube/config --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT --profile DEFAULT