#!/bin/bash
echo "Задача 1:  Настроить iptables: разрешить подключения только на 22-й и 80-й порты"
sudo iptables -P INPUT DROP
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -L
sleep 5
echo "Задача 2: Настроить проброс портов локально с порта 80 на порт 8080"
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
sudo iptables -L
sleep 5

echo "Задача 3: Запретить любой входящий трафик с IP-адреса 3.4.5.6"
sudo iptables -A INPUT -s 3.4.5.6 -j DROP
sudo iptables -L
sleep 5

echo "Задача 4: Запустите mc. Используя ps, найдите PID процесса, завершите процесс, передав ему сигнал 9"
mc &
ps | grep [m]c
sleep 5
MC=$(ps | grep [m]c | awk '{print $1}')
kill -9 $MC
clear