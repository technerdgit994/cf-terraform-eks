resource "aws_security_group"  "eks-cluster-sg" {
	name 	= "eks-cluster-sg"
	description = "Clsuter communication with worker nodes"
	vpc_id	= "${aws_vpc.eks-cluster.id}"

	egress {
	 	from_port	=0
		to_port		=0 
		protocol	="-1"
		cidr_blocks	=["0.0.0.0/0"]
	}
	tags = {
	   Name = "eks-cluster-sg"
	}
}

resource "aws_security_group_rule" "eks-cluster-ingress-workstation-https" {
  cidr_blocks	= ["166.137.242.95/32"]
  description	= "Allow workstation to communicate with the cluster API Server"
  from_port	= 443
  protocol	= "tcp"
  security_group_id = "${aws_security_group.eks-cluster-sg.id}"
  to_port 	= 443
  type		= "ingress"
}
