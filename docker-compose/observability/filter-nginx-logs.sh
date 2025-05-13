echo
echo "Top IP addresses accessing the website:"
echo
awk '{print $1}' /var/log/nginx/yohrannes.com-access.log | sort | uniq -c | sort -nr | head -20
echo
echo "Top Urls accessed:"
echo
awk '{print $7}' /var/log/nginx/yohrannes.com-access.log | sort | uniq -c | sort -nr
echo
echo "Top 20 User Agents:"
echo
awk -F\" '{print $6}' /var/log/nginx/yohrannes.com-access.log | sort | uniq -c | sort -nr | head -20
echo
echo "Top 20 Referrers:"
echo
awk -F\" '{print $4}' /var/log/nginx/yohrannes.com-access.log | sort | uniq -c | sort -nr | head -20
echo
echo "Top 20 Status Codes:"
echo
awk '{print $9}' /var/log/nginx/yohrannes.com-access.log | sort | uniq -c | sort -nr | head -20
echo
