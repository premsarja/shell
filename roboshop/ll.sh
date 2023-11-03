#!/bin/bash 

# aws ec2 run-instances --image-id ami-0c1d144c8fdd8d690 --count 1 --instance-type t2.micro  --security-group-ids sg-00f2ddd66e34b1879
HOSTED_ID=Z01927153H3BLSGWLBLEA
 
PRIVATE_IP=$(aws ec2 run-instances --image-id ami-0c1d144c8fdd8d690 --instance-type t2.micro  --security-group-ids sg-00f2ddd66e34b1879 | jq '.Instances[].PrivateIpAddress' | sed -e '\s\"\\g')
echo $PRIVATE_IP