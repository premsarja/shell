#/bin/bash

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

echo -e "\e[35m  configuring frontend ......!!! \e[0m"

echo -n "installing frontend: "
yum install nginx -y &>> /tmp/frontend.log
STATUS $?

echo  -n -e "\e[35m starting the service:"
systemctl enable nginx
systemctl start nginx
STATUS $?

echo -n "downloading the component:"

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" &>> /tmp/frontend.log
STATUS $?

echo "installing the downloaded component file"
cd /usr/share/nginx/html
STATUS $?

echo -n "removing the deafault content of file;"
rm -rf *
STATUS $?

echo -n "unzipping the content from the file;"
unzip /tmp/frontend.zip
STATUS $?

echo -n "unzimoving file to current directory;"
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
STATUS $?

echo -n "move the roboshop conf file to nginx default directory"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
STATUS $?