resource "aws_autoscaling_group" "eks-worker-asg" {
  desired_capacity 	= 2
  launch_configuration	= "${aws_launch_configuration.eks-worker-launch-config.id}"
  max_size		= 2
  min_size		= 1
  name			= "eks-worker-asg"
  vpc_zone_identifier	= "${aws_subnet.eks-subnet.*.id}"

  tag {
	key			= "Name"
	value			= "eks-worker-asg"
	propagate_at_launch	= true
  }

  tag {
   	key			= "kubernetes.io/cluster/${var.cluster-name}"
	value			= "owned"
	propagate_at_launch	= true
  }
}

