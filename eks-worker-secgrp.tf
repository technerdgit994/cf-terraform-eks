data "aws_security_group" "eks-cluster-sg" {
   id = "${aws_security_group.eks-cluster-sg.id}"
}

resource "aws_security_group" "eks-worker-sg" {
   name 	= "eks-worker-sg"
   description  = "Security Group for all worker nodes in the cluster"
   vpc_id	= "${aws_vpc.eks-cluster.id}"

   egress {
	from_port	= 0
	to_port		= 0
	protocol	= "-1"
	cidr_blocks	= ["0.0.0.0/0"]
   }

   tags = "${
	map(
	   "Name", "eks-worker-sg",
	   "kubernetes.io/cluster/${var.cluster-name}", "owned",
      )
    }"
 }


resource "aws_security_group_rule" "eks-worker-ingress-self" {
   description		= "Allow node to communicate with each other"
   from_port		= 0
   protocol		= "-1"
   security_group_id	= "${aws_security_group.eks-worker-sg.id}"
   source_security_group_id = "${aws_security_group.eks-worker-sg.id}"
   to_port		= 65535
   type			= "ingress"
}

resource "aws_security_group_rule" "eks-worker-ingress-cluster" {
   description 		= "Allow worker kubelets and pods to receive communication from cluster control plane"
   from_port		= 1025
   protocol		= "tcp"
   security_group_id	="${aws_security_group.eks-worker-sg.id}"
   source_security_group_id = "${data.aws_security_group.eks-cluster-sg.id}"
   to_port		= 65535
   type			= "ingress"
}
