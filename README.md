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

## Step