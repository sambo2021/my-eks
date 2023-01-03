resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.business_divsion}-${var.environment}/network/vpc_id"
  type        = "String"
  value       = module.vpc.vpc_id
}
resource "aws_ssm_parameter" "vpc_cidr_block" {
  name        = "/${var.business_divsion}-${var.environment}/network/vpc_cidr_block"
  type        = "String"
  value       =  module.vpc.vpc_cidr_block
}
resource "aws_ssm_parameter" "private_subnets_cidr" {
  name        = "/${var.business_divsion}-${var.environment}/network/private_subnets_cidr"
  type        = "StringList"
  value       = join(",",var.vpc_private_subnets)
}
resource "aws_ssm_parameter" "public_subnets_cidr" {
  name        = "/${var.business_divsion}-${var.environment}/network/public_subnets_cidr"
  type        = "StringList"
  value       = join(",", var.vpc_public_subnets)
}

resource "aws_ssm_parameter" "nat_public_ips" {
  name        = "/${var.business_divsion}-${var.environment}/network/nat_public_ips"
  type        = "StringList"
  value       = join(",", module.vpc.nat_public_ips)
}
resource "aws_ssm_parameter" "azs" {
  name        = "/${var.business_divsion}-${var.environment}/network/azs"
  type        = "StringList"
  value       = join(",", module.vpc.azs) 
}

resource "aws_ssm_parameter" "private_subnets_id" {
  name        = "/${var.business_divsion}-${var.environment}/network/private_subnets_id"
  type        = "StringList"
  value       = join(",", module.vpc.private_subnets)
}

resource "aws_ssm_parameter" "public_subnets_id" {
  name        = "/${var.business_divsion}-${var.environment}/network/public_subnets_id"
  type        = "StringList"
  value       = join(",", module.vpc.public_subnets)
}