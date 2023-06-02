#!/bin/bash
echo "Задача 2. Установить Docker"
sleep 5
sudo apt -y install docker.io
echo "Задача 3. Запустить контейнер с Ubuntu"
echo "Не забудьте выйти из контейнера ubuntu введя exit"
sleep 5
sudo docker run -it ubuntu
echo "Задача 4. * Используя Dockerfile, собрать связку nginx + PHP-FPM в одном контейнере"
sleep 5
mkdir nginx-fpm
cd nginx-fpm
cat > Dockerfile <<EOF
FROM ubuntu:22.04
LABEL maintainer="Rostislav Romashin"
LABEL version="0.1"
LABEL description="For GeekBrain's linux homework"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y install nginx php-fpm supervisor
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/8.1/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etc/supervisor/supervisord.conf
COPY default \${nginx_vhost}
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' \${php_conf} && echo "\ndaemon off;" >> \${nginx_conf}
COPY supervisord.conf \${supervisor_conf}
RUN mkdir -p /run/php
RUN chown -R www-data:www-data /var/www/html
RUN chown -R www-data:www-data /run/php
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]
COPY start.sh /start.sh
CMD ["./start.sh"]
EXPOSE 80
EOF
cat > default <<EOF
server {
    listen 80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
 
    server_name _;
 
    location / {
        try_files \$uri \$uri/ =404;
    }
 
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }
}
EOF
cat > supervisord.conf <<EOF
[unix_http_server]
file=/dev/shm/supervisor.sock
[supervisord]
logfile=/var/log/supervisord.log 
logfile_maxbytes=50MB
logfile_backups=10 
loglevel=info
pidfile=/tmp/supervisord.pid 
nodaemon=false
minfds=1024
minprocs=200
user=root
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
[supervisorctl]
serverurl=unix:///dev/shm/supervisor.sock
[include]
files = /etc/supervisor/conf.d/*.conf
[program:php-fpm8.1]
command=/usr/sbin/php-fpm8.1 -F
numprocs=1
autostart=true
autorestart=true
[program:nginx]
command=/usr/sbin/nginx
numprocs=1
autostart=true
autorestart=true
EOF
cat > start.sh <<EOF
#!/bin/sh
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
EOF
chmod +x start.sh
sudo docker build -t nginx-fpm .
sleep 7
echo "Запускаю контейнер.."
sudo mkdir -p /var/webroot
sudo docker run -d -v /var/webroot:/var/www/html -p 8080:80 --name test-container nginx-fpm
echo "<h1>Nginx and PHP-FPM 8.1 inside Docker Container with Ubuntu 22.04 Base Image</h1>" | sudo tee /var/webroot/index.html
echo "<?php phpinfo(INFO_LICENSE); ?>" | sudo tee /var/webroot/info.php
curl localhost:8080
curl localhost:8080/info.php

