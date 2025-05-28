output "app_ips" {
  value = [aws_instance.django_app[*].private_ip]
}

output "db_ips" {
  value = [aws_instance.db[*].private_ip]
}