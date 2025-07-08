resource "aws_instance" "k8s-hard-way-ec2-instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.k8s_hard_way_public_subnet[count.index % length(aws_subnet.k8s_hard_way_public_subnet)].id
  count         = 4
  security_groups = [aws_security_group.allow_all_sg.id]

  tags = {
    Name = "k8s-hard-way-ec2-instance-${count.index}"
  }
}