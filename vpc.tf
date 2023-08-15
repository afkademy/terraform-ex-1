resource "aws_vpc" "webapp_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "${local.common_tags["Env"]}-${local.common_tags["Team"]}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.webapp_vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
    Env= local.common_tags["Env"]
    Team= local.common_tags["Team"]
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.webapp_vpc.id
  cidr_block = var.public_cidr
  availability_zone = var.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet"
    Env= local.common_tags["Env"]
    Team= local.common_tags["Team"]
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.webapp_vpc.id
  cidr_block = var.private_cidr
  availability_zone = var.azs[1]
  tags = {
    Name = "${var.vpc_name}-private-subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.webapp_nat.id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}


resource "aws_route_table_association" "rt_pub_ass" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_pri_ass" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_eip" "nat_eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "webapp_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.vpc_name}-natgw"
  }

  depends_on = [aws_internet_gateway.igw]
}






