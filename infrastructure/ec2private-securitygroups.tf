# AWS EC2 Security Group Terraform Module
# Security Group for Public Bastion Host
module "private_instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.5.0"
  name = "${local.name}-private-instance-sg"
  description = "Security Group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks -> names are shown on module page 
  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = var.vpc_public_subnets
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags = local.common_tags
}