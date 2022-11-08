#### VPC creation #####
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = local.common_tags
}

### subnets ###
resource "aws_subnet" "private-sub1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.privateSubnets1_cidr_block
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = local.common_tags
}
resource "aws_subnet" "private-sub2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.privateSubnets2_cidr_block
  availability_zone = data.aws_availability_zones.azs.names[1]

  tags = local.common_tags
}
resource "aws_subnet" "pub-sub1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.publicSubnets1_cidr_block
  availability_zone = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true

  tags = local.common_tags
}
resource "aws_subnet" "pub-sub2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.publicSubnets2_cidr_block
  availability_zone = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true

  tags = local.common_tags
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.common_tags
}
