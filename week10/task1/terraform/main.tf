terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    control_plane = {
      private_ip = aws_instance.k8s-hard-way-ec2-instance[1].private_ip
      user       = "masterk8s"
    },
    workers = [
      {
        name       = "node-0"
        private_ip = aws_instance.k8s-hard-way-ec2-instance[2].private_ip
        user       = "worker0"
      },
      {
        name       = "node-1"
        private_ip = aws_instance.k8s-hard-way-ec2-instance[3].private_ip
        user       = "worker1"
      }
    ]
  })

  filename = "${path.module}/../ansible/inventory.ini"
}