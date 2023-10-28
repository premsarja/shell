#!/bin/bash

echo "i am fronten catalogue"

ID=roboshop
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

echo -ne "\e[33m installing the nodejs component \e[0m ; "
sudo yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> /tmp/catalogue.log
yum install nodejs -y  &>> /tmp/catalogue.log
STATUS $?

echo -ne "\e[33m creating roboshop user \e[0m"
id=${ID}
if [[ id -ne 0 ]]; then
  useradd roboshop
fi
STATUS $?

echo -ne " installing the component " 
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
cd /home/roboshop
unzip -o /tmp/catalogue.zip &>> /tmp/catalogue.log
STATUS $?

echo -n "moving component: "
mv -f catalogue-main catalogue
cd /home/roboshop/catalogue
npm install &>> /tmp/catalogue.log
STATUS $?
