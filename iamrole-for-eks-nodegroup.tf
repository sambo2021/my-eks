# IAM Role for EKS Node Group 
resource "aws_iam_role" "eks_nodegroup_role" {
  name = "${local.name}-eks-nodegroup-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodegroup_role.name
}


//aws iam policy for using ebs csi driver, this policy would be attached to iam role of each ec2 of worker group 
//to allow pods on them to call ebs drivers 
data "aws_iam_policy_document" "aws_ebs_csi_driver" {
    statement{
        sid="storageactions"
        actions=[
           "ec2:AttachVolume",
           "ec2:CreateSnapshot",
           "ec2:CreateTags",
           "ec2:CreateVolume",
           "ec2:DeleteSnapshot",
           "ec2:DeleteTags",
           "ec2:DeleteVolume",
           "ec2:DescribeInstances",
           "ec2:DescribeSnapshots",
           "ec2:DescribeTags",
           "ec2:DescribeVolumes",
           "ec2:DetachVolume"
        ]
        effect = "Allow"
        resources= ["*"]
  }
}
resource "aws_iam_policy" "aws_ebs_csi_driver_policy" {
  name= "aws-ebs-csi-driver-policy"
  policy = data.aws_iam_policy_document.aws_ebs_csi_driver.json
}
resource "aws_iam_role_policy_attachment" "aws_ebs_csi_driver_policy_attachment" {
  policy_arn = aws_iam_policy.aws_ebs_csi_driver_policy.arn
  role       = aws_iam_role.eks_nodegroup_role.name
}