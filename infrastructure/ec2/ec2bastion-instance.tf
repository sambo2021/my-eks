# this creating a key on your local machine and assign its public one to ec2 instance 
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}
resource "aws_key_pair" "TF_key" {
  key_name = var.instance_keypair
  public_key = tls_private_key.rsa.public_key_openssh
    provisioner "local-exec" { 
    #Create "TF_key.pem" to your computer!!
    command = <<-EOT
     echo '${tls_private_key.rsa.private_key_pem}' > ${path.cwd}/private-key/eks-terraform-key.pem
     chmod 400 ${path.cwd}/private-key/eks-terraform-key.pem 
     EOT
  }
}


# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"
  # insert the required variables here
  name                   = "${local.name}-BastionHost"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  #monitoring             = true
  subnet_id              = split(",",data.aws_ssm_parameter.public_subnets_id.value)[0] #module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  tags = local.public_ec2_tags
   depends_on = [
    tls_private_key.rsa,
    aws_key_pair.TF_key,

  ]
}

# Create Elastic IP for Bastion Host
# Resource - depends_on Meta-Argument
resource "aws_eip" "bastion_eip" {
  #depends_on = [ module.ec2_public, module.vpc ]
  instance = module.ec2_public.id
  vpc      = true
  tags = local.common_tags
}


