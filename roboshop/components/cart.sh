#!/bin/bash 

echo "i am cart"


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
yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
yum install nodejs -y 
STATUS $?

echo -ne "\e[33m creating roboshop user \e[0m ; "
ID=roboshop
id=${ID}
  id ${id}  
  if [ $? -ne 0 ] ; then 
      echo -n "Creating Application User Account :"
      useradd roboshop
      STATUS $? 
  fi    
STATUS $?

echo -ne " installing the component " 
cd /home/roboshop
curl -s -L -o /tmp/cart.zip "https://github.com/stans-robot-project/cart/archive/main.zip"
unzip -o /tmp/cart.zip &>> /tmp/cart.log
STATUS $?

echo -n "moving component: "
mv //home/roboshop/cart-main cart
cd /home/roboshop/cart
chown -R roboshop:roboshop 
npm install
STATUS $?

echo -n "updating the file:  "
# sed -i -e 's/REDIS_ENDPOINT/172.31.27.233/' -e 's/CATALOGUE_ENDPOINT/172.31.16.108/' /home/roboshop/cart/systemd.service
STATUS $?

echo -n "starting the systemfile: "
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl start cart
systemctl status cart -l
STATUS $?