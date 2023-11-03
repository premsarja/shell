#!/bin/bash 

# aws ec2 run-instances --image-id ami-0c1d144c8fdd8d690 --count 1 --instance-type t2.micro  --security-group-ids sg-00f2ddd66e34b1879
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7"| jq ".Images[].ImageId" | sed -e 's/"//g')
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP=$(aws ec2 describe-security-groups --filters Name=group-name,Values=default | jq '.SecurityGroups[].GroupName'| sed -e 's/"//g')
HOSTEDZONE_ID="Z01927153H3BLSGWLBLEA"
COMPONENT=$1
env="dev"
if [ -z $1 ]; then
  echo -e "\e[31m COMPONENT name is needed\e[0m"
  echo -e "\e[35m ex;usage $bash launch-ec2.sh \e[0m"
  exit 1
fi  

# HOSTED_ID=Z01927153H3BLSGWLBLEA

echo $AMI_ID $INSTANCE_TYPE $SECURITY_GROUP $HOSTED_ID

PRIVATE_IP=$(aws ec2 run-instances --image-id ami-0c1d144c8fdd8d690 --instance-type t2.micro  --security-group-ids sg-00f2ddd66e34b1879 | jq '.Instances[].PrivateIpAddress' | sed -e 's\"\\g')
echo $PRIVATE_IP

echo "creating the DNS record of ${COMPONENT}"

sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATE_IP}/" route53.JSON > /tmp/r53.json
HOSTED_ID=Z01927153H3BLSGWLBLEA

aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONE_ID --change-batch file:///tmp/r53.json

echo "private IPADDRESS of $COMPONENT is created and ready to use on ${COMPONENT}.roboshop-internal"