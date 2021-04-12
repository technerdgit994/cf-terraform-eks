resource "aws_security_group_rule" "eks-cluster-ingress-to-worker-https" {
  description		=  "Allow pods to communicate with cluster API Server"
  from_port		=  443
  protocol		=  "tcp"
  security_group_id	= "${aws_security_group.eks-worker-sg.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-sg.id}"
  to_port		= 443
  type			= "ingress"
}
