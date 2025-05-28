terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }

  backend "s3" {
    encrypt      = true
    bucket       = "backend-58490149"
    region       = "eu-north-1"
    key          = "terraform.tfstate"
    use_lockfile = true
  }
  required_version = "~> 1.10"
}

resource "local_file" "ansible_inventory" {
  content  = templatefile("${path.module}/inventory.tpl", {
    app_ips = aws_instance.django_app[*].private_ip
    db_ips  = aws_instance.db[*].private_ip
  })
  filename = "${path.module}/inventory.ini"
}