data "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.business_divsion}-${var.environment}/network/vpc_id"
}
data "aws_ssm_parameter" "vpc_cidr_block" {
  name        = "/${var.business_divsion}-${var.environment}/network/vpc_cidr_block"
}
data "aws_ssm_parameter" "private_subnets_id" {
  name        = "/${var.business_divsion}-${var.environment}/network/private_subnets_id"
}
data "aws_ssm_parameter" "public_subnets_id" {
  name        = "/${var.business_divsion}-${var.environment}/network/public_subnets_id"
}
data "aws_ssm_parameter" "private_subnets_cidr" {
  name        = "/${var.business_divsion}-${var.environment}/network/private_subnets_cidr"
}
data "aws_ssm_parameter" "public_subnets_cidr" {
  name        = "/${var.business_divsion}-${var.environment}/network/public_subnets_cidr"
}

data "aws_ssm_parameter" "nat_public_ips" {
  name        = "/${var.business_divsion}-${var.environment}/network/nat_public_ips"
}
data "aws_ssm_parameter" "azs" {
  name        = "/${var.business_divsion}-${var.environment}/network/azs"
}
