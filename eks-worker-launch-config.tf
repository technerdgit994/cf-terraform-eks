data "aws_region" "current" {}

locals {
    eks-worker-userdata = <<USERDATA
   #!/bin/bash
   set  -o xtrace
   /etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-cluster.certificate_authority.0.data}'  '${var.cluster-name}'
   USERDATA
}

resource "aws_launch_configuration" "eks-worker-launch-config" {
   associate_public_ip_address 	= true
   iam_instance_profile		= "${aws_iam_instance_profile.eks-instance-profile.name}"
   image_id			= "${data.aws_ami.eks-worker-ami.id}"
   instance_type		= "t2.micro"
   name_prefix			= "eks-worker"
   security_groups		= ["${aws_security_group.eks-worker-sg.id}"]
   user_data_base64		= "${base64encode(local.eks-worker-userdata)}"

   lifecycle {
  	create_before_destroy = true
   }
}
