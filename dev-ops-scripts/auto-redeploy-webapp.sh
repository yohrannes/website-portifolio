echo "0 * * * * python3 /root/repos-github/docker-lenda/lenda/scripts/get-last-commit.py" >> /etc/crontab
echo crontab ok!
cat /etc/crontab | tail -1
