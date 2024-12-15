server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://flask-app:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    access_log /var/log/nginx/oracle-instance.yohrannes.com-access.log upstream_time;
    error_log /var/log/nginx/oracle-instance.yohrannes.com-error.log warn;
}