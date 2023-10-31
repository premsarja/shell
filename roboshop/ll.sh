AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq -r ".Images[0].ImageId")
INSTANCE_TYPE="t2.micro"
SECURITY_GROUP=$(aws ec2 describe-security-groups --filters Name=group-name,Values=default | jq -r '.SecurityGroups[0].GroupName')
HOSTEDZONE_ID="Z01927153H3BLSGWLBLEA"
COMPONENT=$1

if [ -z "$COMPONENT" ]; then
  echo -e "\e[31m COMPONENT name is needed\e[0m"
  echo -e "\e[35m ex; usage $bash launch-ec2.sh COMPONENT_NAME \e[0m"
  exit 1
fi

aws ec2 run-instances --image-id "$AMI_ID" --instance-type "$INSTANCE_TYPE" --security-group-ids "$SECURITY_GROUP" --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"

PRIVATE_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" | jq -r '.Reservations[0].Instances[0].PrivateIpAddress')

echo "The private IP of ${COMPONENT} is ${PRIVATE_IP}"
echo "AMI ID: ${AMI_ID}"

echo "Creating the DNS record for ${COMPONENT}"

sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATE_IP}/" route53.JSON > /tmp/r53.json
aws route53 change-resource-record-sets --hosted-zone-id "$HOSTEDZONE_ID" --change-batch file:///tmp/r53.json

echo "Private IP address of $COMPONENT is created and ready to use at ${COMPONENT}.roboshop-internal"
