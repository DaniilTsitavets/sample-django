output "db_name" {
  value = data.aws_ssm_parameter.db_name
}

output "db_username" {
  value = data.aws_ssm_parameter.db_username
  sensitive = true
}
output "db_password" {
  value = data.aws_ssm_parameter.db_password
  sensitive = true
}