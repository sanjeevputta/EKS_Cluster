#In this We are creating VPC, Subnet, Internetgateway & Routtable

resource "aws_vpc" "QA" {
  cidr_block = "10.0.0.0/16"

  tags = tomap({
    "Name"                                      = "EKS-QA-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

resource "aws_subnet" "QA" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.QA.id

  tags = tomap({
    "Name"                                      = "EKS-QA-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

resource "aws_internet_gateway" "QA" {
  vpc_id = aws_vpc.QA.id

  tags = {
    Name = "EKS_QA"
  }
}

resource "aws_route_table" "QA" {
  vpc_id = aws_vpc.QA.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.QA.id
  }
}

resource "aws_route_table_association" "QA" {
  count = 2

  subnet_id      = aws_subnet.QA.*.id[count.index]
  route_table_id = aws_route_table.QA.id
}
