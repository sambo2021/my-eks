# Define Local Values in Terraform
locals {
  owners = var.business_divsion
  environment = var.environment
  name = "${var.business_divsion}-${var.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
  public_ec2_tags ={
    owners = local.owners
    environment = local.environment
    type = "public"
  }
  private_ec2_tags ={
    owners = local.owners
    environment = local.environment
    type = "private"
  }
  eks_cluster_name = "${local.name}-${var.cluster_name}"  
} 