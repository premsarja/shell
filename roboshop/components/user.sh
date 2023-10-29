#!/bin/bash 

echo "i am  user"

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
yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
yum install nodejs -y 
STATUS $?

echo -ne "\e[33m creating roboshop user \e[0m ; "
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
curl -s -L -o /tmp/user.zip "https://github.com/stans-robot-project/user/archive/main.zip"
unzip -o /tmp/user.zip &>> /tmp/user.log
STATUS $?

echo -n "moving component: "
mv user-main user
cd /home/roboshop/user
chown -R roboshop:roboshop /home/roboshop/user
cd /home/roboshop/user
npm install
STATUS $?

echo -n "updating the file:  "
# sed -ie 's/MONGO_ENDPOINT/172.31.20.91/' /home/roboshop/user/systemd.service
# sed -ie 's/REDIS_ENDPOINT/172.31.27.233/' /home/roboshop/user/systemd.service
STATUS $?

echo -n "starting the systemfile: "
# mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
systemctl daemon-reload
systemctl start user
systemctl status user -l
STATUS $?