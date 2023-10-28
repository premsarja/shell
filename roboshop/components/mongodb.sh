#?/bin/bash 

echo "i am mongoDb"

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


echo -ne "\e[33m downloading the Db directory which provided by devloper \e[0m; "
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
STATUS $?

echo -ne "\e[33m downloading the mongoDb ......! \e[0m; " 
yum install -y mongodb-org
systemctl enable mongod
systemctl start mongod
STATUS $?

echo -ne "\e[33m update the < bind IP > ......! \e[0m; "
sed -ie "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
STATUS $?

echo -ne "\e[33m starting mongodb \e[0m: "
systemctl enable mongod
systemctl start mongod
STATUS $?


echo -ne "\e[33m download and install schema : "
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
cd /tmp
unzip -o mongodb.zip &>> /tmp/mongod.log
cd mongodb-main
mongo < catalogue.js
mongo < users.js
STATUS $?


