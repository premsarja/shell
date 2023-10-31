#!/bin/bash

# ami id
# type of instance 
# security_group
# instance_you_need
# DNS record hosted zone id

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7"| jq ".Images[].ImageId" | sed -e 's/"//g')
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP=$(aws ec2 describe-security-groups --filters Name=group-name,Values=default | jq '.SecurityGroups[].GroupName'| sed -e 's/"//g')
HOSTEDZONE_ID="Z01927153H3BLSGWLBLEA"
COMPONENT=$1
env="env"
if [ -z $1 ]; then
  echo -e "\e[31m COMPONENT name is needed\e[0m"
  echo -e "\e[35m ex;usage $bash launch-ec2.sh \e[0m"
  exit 1
fi  

#   aws ec2 run-instances --image-id ${AMI_ID} --count 1 --instance-type ${INSTANCE_TYPE} --security-group-ids ${SECURITY_GROUP} --subnet-id subnet-6e7f829e 

#EACH AND EVERY RESOURCE THAT WE CREATE IN ENTERPRISE(ORGANISATION LEVEL) WILL HAVE TAGS.
# BU,ENV,APP:COST_CENTER

# aws ec2 run-instances --image-id ami-0c1d144c8fdd8d690 --instance-type ${INSTANCE_TYPE} --security-group-ids ${SECURITY_GROUP} --tag-specification "ResourceType=instance,Tags=[{key=Name,Value=1}]"
PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type ${INSTANCE_TYPE} --security-group-ids sg-071baaff364d61305 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

echo "THE private ip of ${COMPONENT} is ${PRIVATE_IP}"
echo ${AMI_ID}

echo "creating the DNS record of ${COMPONENT}"

sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATE_IP}/" route53.JSON > /tmp/r53.json
aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONE_ID --change-batch file:///tmp/r53.json

echo "private IPADDRESS of $COMPONENT is created and ready to use on ${COMPONENT}.roboshop-internal"