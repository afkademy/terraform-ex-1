resource "aws_security_group" "webapp_sg" {
  name        = "${var.vpc_name}-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.webapp_vpc.id

 dynamic "ingress" {
   for_each = local.inbound_rules
   content {
    from_port        = ingress.value
    to_port          = ingress.value
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-sg"
    Env= local.common_tags["Env"]
    Team= local.common_tags["Team"]
  }
}