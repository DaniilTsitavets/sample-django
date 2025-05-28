resource "aws_instance" "django_app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count                = 2
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "django_app"
    Role = "app"
  }
}


resource "aws_instance" "db" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count                = 1
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "db"
    Role = "db"
  }
}
