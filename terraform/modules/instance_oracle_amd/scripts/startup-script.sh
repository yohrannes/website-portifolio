#!/bin/bash

exec > /var/log/startup-script.log 2>&1
set -x


# 22 (SSH)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 22 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 22 -j ACCEPT
# ICMP (Ping)
sudo iptables -I INPUT 6 -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -I INPUT 6 -p icmp --icmp-type echo-reply -j ACCEPT
# HTTP + HTTPS
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 80 -j ACCEPT

sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 443 -j ACCEPT

#CPANEL
# 1 (CPAN)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 1 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 1 -j ACCEPT

# 7 (Razor)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 7 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 7 -j ACCEPT

# 20 e 21 (FTP)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 20 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 20 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 21 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 21 -j ACCEPT

# 25 e 26 (SMTP)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 25 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 25 -j ACCEPT
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 26 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 26 -j ACCEPT

# 37 (rdate)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 37 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 37 -j ACCEPT

# 43 (whois)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 43 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 43 -j ACCEPT

# 53 (DNS)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 53 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 53 -j ACCEPT


# 110 (POP3)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 110 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 110 -j ACCEPT

# 113 (ident)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 113 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 113 -j ACCEPT

# 143 (IMAP)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 143 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 143 -j ACCEPT

# 465 (SMTP, SSL/TLS)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 465 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 465 -j ACCEPT

# 783 (SpamAssassin)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 783 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 783 -j ACCEPT

# 873 (rsync)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 873 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 873 -j ACCEPT

# 3306 (MySQL)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 3306 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 3306 -j ACCEPT

# 11371 (APT)
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 11371 -j ACCEPT
sudo iptables -I OUTPUT 6 -m state --state NEW -p tcp --sport 11371 -j ACCEPT

sudo netfilter-persistent save

sudo apt-get install -y nano net-tools wget curl jq htop traceroute mtr dnsutils tmux

sudo su
whoami
cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
echo "startup-script-finished"
