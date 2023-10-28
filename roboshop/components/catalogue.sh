#!/bin/bash

echo "i am frontend"

USER_ID=$(id -u)
ID=roboshop

if [[ $USER_ID -ne 0 ]] ; then
   echo -e "\e[31m please be ROOT user \e[0m  \n \t EXAMPLE: sudo <filename> "
   exit 1
fi

STATUS() {
    if [[ $? -eq 0 ]]; then
  echo -e "\e[32m sucees \e[0m" 
else
  echo -e "\e[33m failed \e[0m" 
  exit 2
fi
}

echo -n "\e[33m installing the nodejs component \e[0m ; "
sudo yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> /tmp/catalogue.log
yum install nodejs -y  &>> /tmp/catalogue.log
STATUS $?

echo -ne "\e[33m creating roboshop user \e[0m"
if [[ ID -ne 0 ]]; then
useradd roboshop
STATUS $?