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
unzip -o /tmp/catalogue.zip &>> /tmp/catalogue.log
STATUS $?

echo -n "moving component: "
mv -f /home/roboshop/catalogue-main  /home/roboshop/catalogue  &>/dev/null
cd /home/roboshop/catalogue
chown -R roboshop:roboshop /home/roboshop/catalogue
cd /home/roboshop/catalogue
npm install &>> /tmp/catalogue.log
STATUS $?

echo -n "updating the ${COMPONENT} systemfile: "
 sed -ie 's/MONGO_DNSNAME/172.31.20.91/g' /home/roboshop/catalogue/systemd.service #this needs to be run only once
STATUS $?

echo -n "moving the  systemfile: "
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service #this needs to be run only once
STATUS $?

echo -n "starting the systemfile: "
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
systemctl status catalogue -l
STATUS $?

