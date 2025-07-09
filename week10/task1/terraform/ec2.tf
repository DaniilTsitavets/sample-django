resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.k8s_hard_way_public_subnet[0].id
  count         = 1
  security_groups = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "k8s-hard-way-ec2-instance" {
  ami           = var.ami
  instance_type = var.other_nodes_instance_type
  subnet_id     = aws_subnet.k8s_hard_way_public_subnet[count.index % length(aws_subnet.k8s_hard_way_public_subnet)].id
  count         = 3
  security_groups = [aws_security_group.other_nodes_sg.id]

  tags = {
    Name = "k8s-hard-way-ec2-instance-${count.index}"
  }
}