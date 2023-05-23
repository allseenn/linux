#!/bin/bash 
echo "Задача 1: Подключить репозиторий с nginx любым удобным способом, установить nginx и потом удалить nginx, используя утилиту dpkg"
sudo apt -y install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
sudo gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl status nginx
echo "`nginx -v` установлен и запущен! Удаление через 5 секунд"
sleep 5
echo "Удаляю nginx"
sudo systemctl stop nginx
sudo systemctl disable nginx
sudo dpkg --purge nginx
sudo rm -f /etc/apt/sources.list.d/nginx.list
sudo rm -f /etc/apt/preferences.d/99nginx
echo "Nginx удален"
sleep 5
echo "Задача 2: Установить пакет на свой выбор, используя snap"
sudo snap install telegram-cli
echo "Telegram установлен"
sleep 5
sudo snap remove telegram-cli
echo "Telegram удален"
sleep 5
echo "Задача 3: * Создать с помощью nano файл test.txt. Настроить автоматический бэкап этого файла раз в 10 минут в файл с названием test.txt.bak с использованием cron"
echo "Подождем 5 сек и NANO закроется ))" | nano ~/test ; mv ~/test.save ~/test.txt
echo "*/1 * * * * cp ~/test.txt ~/test.txt.bak" >> ~/tmp
crontab ~/tmp
rm ~/tmp
cd 
ls
echo "Каждые 10 минут делаем бэкап"
