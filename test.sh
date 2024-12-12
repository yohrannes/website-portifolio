#!/bin/bash
while true; do if [[ $(tail -n1 /var/log/startup-script.log) == "startup-script-finished" ]]; then echo "finished";break;fi;done