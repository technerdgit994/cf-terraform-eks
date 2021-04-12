# Create a VPC and  subnets internet gateway and routing table for the Elastic Kubernetes Service

# Get the availability zones for the region

data "aws_availability_zones" "available" {}


resource  "aws_vpc" "eks-cluster" {
   cidr_block = "10.0.0.0/16"

tags = "${
   map(
      "Name", "eks-vpc",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
   )
  }"
}

# Create two subnets for the eks cluster
resource "aws_subnet" "eks-subnet" {
  count = 2
  availability_zone 	= "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block 		= "10.0.${count.index}.0/24"
  vpc_id  		= "${aws_vpc.eks-cluster.id}"

  tags = "${
	map(
  	  "Name", "eks-vpc",
	  "kubernetes.io/cluster/${var.cluster-name}", "shared",
       )
    }"
}
# Create internet gateway

resource "aws_internet_gateway" "eks-gw" {

   vpc_id = "${aws_vpc.eks-cluster.id}"
   tags   = {
	Name = "terraform-eks-gw"
   }
}

# Create routing table

resource "aws_route_table" "eks-routing" {

   vpc_id = "${aws_vpc.eks-cluster.id}"
   
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks-gw.id}"
  }
}

# Create routing table association to Subnets

resource "aws_route_table_association" "eks-route-associate" {
    count = 2
    subnet_id  = "${aws_subnet.eks-subnet.*.id[count.index]}"
    route_table_id = "${aws_route_table.eks-routing.id}"
}
