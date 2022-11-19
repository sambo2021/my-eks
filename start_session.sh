#!/usr/bin/env bash

export INSTANCE=`aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value}" --filter "Name=instance-state-name,Values=running" | jq -r .[][0]."Name" | fzf | xargs -I '{}' echo {}`
export PrivateIP=`aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{PrivateIP:NetworkInterfaces[*].PrivateIpAddress}" --filter "Name=tag:Name,Values=$INSTANCE" | jq -r .[0][0]."PrivateIP"[0]`
#there is no use of variable PublicIP, just made it to show you how to find public ip of public ec2 instances 
export PublicIP=`aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{PublicIP:NetworkInterfaces[*].Association.PublicIp}" --filter "Name=tag:Name,Values=$INSTANCE" | jq -r .[0][0]."PublicIP"[0]`
export BastionPublicIP=`aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{PublicIP:NetworkInterfaces[*].Association.PublicIp}" --filter "Name=tag:Name,Values=DXL-Dev-BastionHost" | jq -r .[0][0]."PublicIP"[0]`
echo " >>>>>>> connecting to $INSTANCE"
ssh -o ProxyCommand='ssh -W %h:%p -q -oStrictHostKeyChecking=no -i $PWD/private-key/eks-terraform-key.pem ec2-user@$BastionPublicIP' -oStrictHostKeyChecking=no -i $PWD/private-key/eks-terraform-key.pem ec2-user@$PrivateIP
