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

echo -e "\e[33m  configuring frontend ......!!! \e[0m"

echo -n "installing frontend: "
yum install nginx -y &>> /tmp/frontend.log
STATUS $?

echo  -n -e "\e[33m starting the service \e[0m:"
systemctl enable nginx
systemctl start nginx
STATUS $?

echo -ne "\e[33m downloading the component \e[0m:"

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" &>> /tmp/frontend.log
STATUS $?

echo -ne "\e[33m installing the downloaded component file; \e[0m"
cd /usr/share/nginx/html
STATUS $?

echo -ne "\e[33m removing the deafault content of file \e[0m; "
rm -rf *
STATUS $?

echo -ne "\e[33m unzipping the content from the file \e[0m;" $>> /tmp/frontend.log
unzip /tmp/frontend.zip
STATUS $?

echo -ne "\e[33m unzimoving file to current directory \e[0m;"
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
STATUS $?

echo -ne "\e[33m move the roboshop conf file to nginx default directory \e[0m"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
STATUS $?