#!/bin/bash 

echo "i am redis"

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

echo -n "downloading the repo of redis and installing redis: "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
yum install redis-6.2.13 -y
STATUS $?

echo -n "updating bind ip-address: "
sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf
sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
STATUS $?

echo -n "starting database : "
systemctl enable redis
systemctl start redis
systemctl status redis -l
STATUS $?