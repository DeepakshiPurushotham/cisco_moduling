data "aws_availability_zones" "azs" {
  state = "available"
}

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


resource "aws_route_table" "rtbl" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  

  tags = local.common_tags
}

resource "aws_route_table_association" "public-subnet-1-route-table-association" {
subnet_id           = aws_subnet.pub-sub2.id
route_table_id      = aws_route_table.rtbl.id
}

### Security Group ###
resource "aws_security_group" "sg" {
  vpc_id      = aws_vpc.vpc.id
  name = "demo"
  dynamic "ingress" {
    for_each = var.vpn_range
    iterator = vpn
    content {
      description = "TLS from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [vpn.value]
    }
  }
  /*ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpn_range]
    
  }*/

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}



### instance ###
/*data "aws_ami" "amazon" {
  most_recent = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}*/

resource "aws_iam_role" "ssm-role" {
  name = "AWS-SSM-Role"
  assume_role_policy = "${file("role.tpl")}"
  tags = local.common_tags
}
data "aws_iam_policy" "instance_profile_policy" {
  name = "AmazonSSMFullAccess"
}
resource "aws_iam_policy_attachment" "instance_profile_policyattachment" {
  name       = "instance_profile"
  roles      = [aws_iam_role.ssm-role.name]
  policy_arn = data.aws_iam_policy.instance_profile_policy.arn
}
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.ssm-role.name
}
resource "aws_instance" "web-server" {
  count = var.instanceCount
  ami           = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id = aws_subnet.pub-sub2.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  depends_on = [aws_vpc.vpc]

  tags = local.common_tags
}

### EIP ###
resource "aws_eip" "eip" {
  count = var.instanceCount
  vpc      = true
}
resource "aws_eip_association" "eip_assoc" {
  count = var.instanceCount
  instance_id   = aws_instance.web-server[count.index].id
  allocation_id = aws_eip.eip[count.index].id
  depends_on = [aws_instance.web-server]
}

#####  S3 bucket creation #####
resource "aws_s3_bucket" "s3bucket" {
  bucket = var.bucket_name

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "s3bucket-acl" {
  bucket = aws_s3_bucket.s3bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      #kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "AES256"
    }
  }
}


##### Export VMDK file #####
## Role for export ##
resource "aws_iam_role" "vmdk-role" {
  name = "aws_vmdk_role"
  assume_role_policy = "${file("trust-policy.tpl")}"

  tags = local.common_tags
}

resource "aws_iam_policy" "vmdk_policy" {
  name = "aws_vmdk_policy"
  role = aws_iam_role.vmdk-role.id
  policy = "${file("role-policy.tpl")}"
}

resource "aws_iam_role_policy_attachment" "vmdk-attach" {
  role       = aws_iam_role.vmdk-role.name
  policy_arn = aws_iam_policy.vmdk_policy.arn
}