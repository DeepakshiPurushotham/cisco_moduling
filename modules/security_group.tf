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
