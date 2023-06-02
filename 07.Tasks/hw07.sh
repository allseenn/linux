#!/bin/bash
# sudo apt -y purge apache2 nginx nginx-common php-fpm libapache2-mod-php8.1 mysql-client mysql-server phpmyadmin
echo "Задача 1. Установить Nginx"
sleep 3
sudo apt -y install nginx
sudo systemctl start nginx
echo "Задача 2. * настроить Nginx на работу с PHP-FPM"
sleep 5
sudo apt -y install php-fpm curl
sudo sed -i "/server_name _;/a   \\\n \
    \t location ~ \\.php$ { \n \
        \t\t include snippets/fastcgi-php.conf; \n \
        \t\t root /var/www/html; \n \
        \t\t fastcgi_pass unix:/run/php/php8.1-fpm.sock; \n \
    \t }" /etc/nginx/sites-available/default
sudo echo "<?php phpinfo(INFO_LICENSE) ?>" | sudo tee /var/www/html/info.php
sudo systemctl restart nginx
sleep 5
curl -L localhost/info.php | grep title
echo "Задача 3. Установить Apache"
sleep 5
sudo apt -y install apache2
sudo sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf
sudo systemctl restart apache2
curl -L localhost:8080 | grep HTTP
echo "Задача 4. * Настроить обработку PHP. Добиться одновременной работы с Nginx"
sleep 5
sudo apt -y install libapache2-mod-php8.1
sudo systemctl restart apache2
echo "Задача 5. Настроить схему обратного прокси для Nginx (динамика - на Apache)"
sleep 5
sudo sed -i "/server_name _;/a   \\\n \
    \t location ~* ^.+.(jpg|jpeg|gif|png|ico|css|zip|pdf|txt|tar|js)$ { \n \
        \t\t root /var/www/html; \n \
    \t}" /etc/nginx/sites-available/default
sudo sed -i '/displaying a 404./a \\ \
        \t\t proxy_pass http://localhost:8080; \n \
        \t\t proxy_set_header Host $host; \n \
        \t\t proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; \n \
        \t\t proxy_set_header X-Real-IP $remote_addr;' /etc/nginx/sites-available/default
sudo systemctl restart nginx
echo "Задача 6. Установить MySQL. Создать новую базу данных и таблицу в ней"
sleep 5
sudo apt -y mysql-client mysql-server
sudo systemctl start mysql
mysql -uroot -p <<MYSQL_SCRIPT
CREATE DATABASE mydatabase;
USE mydatabase;
CREATE TABLE mytable (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));
DESCRIBE mytable;
MYSQL_SCRIPT
echo "Задача 7. * Установить пакет phpmyadmin и запустить его веб-интерфейс для управления MySQL"
sleep 5
sudo apt -y install phpmyadmin
curl -L http://192.168.1.9:8080/phpmyadmin/


