echo "15 * * * * python3 /root/repos-github/docker-lenda/lenda/scripts/get-last-commit.py" >> /etc/crontabs/root
echo "crontab ok!"
echo "Actual crontab configs"
cat /etc/crontabs/root
