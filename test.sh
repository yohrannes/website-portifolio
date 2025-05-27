OUTPUT=$(oci lb load-balancer update-load-balancer-shape xxxx --shape-name flexible --shape-details '{"maximum-bandwidth-in-mbps":10,"minimum-bandwidth-in-mbps":10}' --force 2>&1)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ] && echo "$OUTPUT" | grep -q 'same values'; then
    echo "No changes made, the load balancer is already using the specified shape and bandwidth."
    exit 0
elif [ $EXIT_CODE -ne 0 ]; then
    echo "$OUTPUT"
    exit 1
fi