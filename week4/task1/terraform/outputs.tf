output "app_ids" {
  value = [aws_instance.django_app[*].id]
}

output "db_ids" {
  value = [aws_instance.db[*].id]
}
