#!/bin/bash

echo "i am frontend"

USER_ID=$(id -u)

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

echo  "installing the nodeja component"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install nodejs -y
STATUS $?
