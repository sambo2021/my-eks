## Step-00: how to get all public instances names, public ips and some of tags 
```sh
aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{Instance:InstanceId,PublicIP:NetworkInterfaces[*].Association.PublicIp,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name,Type:Tags[?Key=='type']|[0].Value}" --filter "Name=instance-state-name,Values=running" "Name=tag:type,Values=public" 
```
## Step-01: how to get all private instances names, private ips and some of tags 
```sh
aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{Instance:InstanceId,PrivateIP:NetworkInterfaces[*].PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name,Type:Tags[?Key=='type']|[0].Value}" --filter "Name=instance-state-name,Values=running" "Name=tag:type,Values=private" 
```
## Step-02: add next lines to ~/.ssh/config 
```sh
Host ${public-instance} 
  HostName ${bastionhost-public-ip}
  User ec2-user
  IdentityFile ${path.cwd}/private-key/eks-terraform-key.pem
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  ServerAliveInterval 60
  ServerAliveCountMax 30
  ProxyCommand none
Host ${private-instance} 
  HostName ${privatehost-private-ip}
  User ec2-user
  IdentityFile ${path.cwd}/private-key/eks-terraform-key.pem
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  ServerAliveInterval 60
  ServerAliveCountMax 30
  ProxyCommand ssh publichost -W %h:%p
```
## Step-03: from local machine you can ssh to public or private instances as well 
```sh
  ssh privatehost
```
# OR you can use this script directly to connect to one of your instances, this script are using aws, fzf, jq, ssh proxy commands to make it like dropdown list  

```sh
  ./start_session.sh
```


## Step-05: if you want to list all running machins in specefic region using jq tool and make it in dropdownlist view using fzf tool 
```sh
aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value}" --filter "Name=instance-state-name,Values=running" | jq -r .[][0]."Name" | fzf 
```

query to get private ip of selected instance 

```sh

aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{PrivateIP:NetworkInterfaces[*].PrivateIpAddress}" --filter "Name=tag:Name,Values=`aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value}" --filter "Name=instance-state-name,Values=running" | jq .[0][0]."Name"`" | jq -r .[0][0]."PrivateIP"[0]

```

this query echo what you have selected 

```sh
aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value}" --filter "Name=instance-state-name,Values=running" | jq -r .[][0]."Name" | fzf | xargs -I '{}' echo {}

```

this query gives you private ip of selected instance 
```sh
aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{Name:Tags[?Key=='Name']|[0].Value}" --filter "Name=instance-state-name,Values=running" | jq -r .[][0]."Name" | fzf | xargs -I '{}' aws ec2 describe-instances --region "us-east-2" --query "Reservations[*].Instances[*].{PrivateIP:NetworkInterfaces[*].PrivateIpAddress}" --filter "Name=tag:Name,Values={}" | jq -r .[0][0]."PrivateIP"[0]
```