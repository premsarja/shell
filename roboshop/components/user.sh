echo "i am fronten user"

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
if [[ $? -ne 0 ]]; then
  useradd roboshop
fi
STATUS $?

echo -ne " installing the component " 
curl -s -L -o /tmp/user.zip "https://github.com/stans-robot-project/user/archive/main.zip"
cd /home/roboshop
unzip -o /tmp/user.zip &>> /tmp/user.log
STATUS $?

echo -n "moving component: "
mv  /home/roboshop/user-main  /home/roboshop/user  &>/dev/null
cd  /home/roboshop/user
chown -R roboshop:roboshop  /home/roboshop/user
npm install &>> /tmp/user.log
STATUS $?
 
echo -n "updating the file:  "
/home/roboshop/user/systemd.service
sed -ie 's/MONGO_ENDPOINT/172.31.20.91/' /home/roboshop/user/systemd.service
sed -ie 's/REDIS_ENDPOINT/172.31.27.233/' /home/roboshop/user/systemd.service
STATUS $?

echo -n "starting the systemfile: "
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
systemctl daemon-reload
systemctl start user
systemctl status user -l
STATUS $?

