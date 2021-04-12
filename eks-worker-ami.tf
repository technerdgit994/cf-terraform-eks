data "aws_ami" "eks-worker-ami" {
   filter {
     name 	= "name"
     values 	= ["amazon-eks-node-${aws_eks_cluster.eks-cluster.version}-v*"]
  }
     most_recent = true
     owners	 = ["602401143452"]
}

