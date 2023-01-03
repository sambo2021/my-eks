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

resource "aws_ssm_parameter" "ssh_key" {
  name        = "/${var.business_divsion}-${var.environment}/network/ssh_key"
  type        = "String"
  value       = tls_private_key.rsa.private_key_pem
}
  