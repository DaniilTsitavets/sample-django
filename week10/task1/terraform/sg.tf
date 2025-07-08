resource "aws_security_group" "allow_all_sg" {
  name   = "k8s-hard-way-ec2-instance-sg"
  vpc_id = aws_vpc.k8s_hard_way_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-hard-way-ec2-instance-sg"
  }
}