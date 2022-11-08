data "aws_availability_zones" "azs" {
  state = "available"
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

### instance ###
/*data "aws_ami" "amazon" {
  most_recent = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}*/


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



