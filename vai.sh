#!/bin/bash
while true; do
if [ -e /var/log/startup-script.log ]; then
    if [ -r /var/log/startup-script.log ]; then
        if [[ $(tail -n1 /var/log/startup-script.log 2>/dev/null) == "startup-script-finished" ]]; then
            echo "Startup script finished!";
            break;
        fi
    fi
fi
sleep 1
done