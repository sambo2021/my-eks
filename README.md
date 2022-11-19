## Step-00: add next lines to ~/.ssh/config 
```sh
Host publichost 
  HostName ${bastionhost-public-ip}
  User ec2-user
  IdentityFile ${path.cwd}/private-key/eks-terraform-key.pem
  ProxyCommand none
Host privatehost 
  HostName ${privatehost-private-ip}
  User ec2-user
  IdentityFile ${path.cwd}/private-key/eks-terraform-key.pem
  ProxyCommand ssh publichost -W %h:%p
```
## Step-01: from local machine 
```sh
  ssh privatehost
```