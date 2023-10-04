#!/bin/bash

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo -e "\e[33m please perform with root user \e[0m \n
  example:ROOT USER"
  exit 1
fi  

echo -e "\e[32m installing nginx\e[0m"

yum install nginx -y
systemctl enable nginx
systemctl start nginx