module "ec2_private1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"
  # insert the required variables here
  name                   = "${local.name}-PrivateInstance01"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  #monitoring             = true
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.private_instance_sg.security_group_id]
  tags = local.private_ec2_tags
   depends_on = [
    tls_private_key.rsa,
    aws_key_pair.TF_key,

  ]
}

module "ec2_private2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"
  # insert the required variables here
  name                   = "${local.name}-PrivateInstance02"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  #monitoring             = true
  subnet_id              = module.vpc.private_subnets[1]
  vpc_security_group_ids = [module.private_instance_sg.security_group_id]
  tags = local.private_ec2_tags
   depends_on = [
    tls_private_key.rsa,
    aws_key_pair.TF_key,

  ]
}