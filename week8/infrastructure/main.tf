terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

resource "local_file" "helm_values" {
  content = templatefile("${path.module}/values.yaml.tpl", {
    repository   = aws_ecr_repository.task1_ecr.repository_url
    db_user      = data.aws_ssm_parameter.db_username.value
    db_password  = data.aws_ssm_parameter.db_password.value
    db_name      = data.aws_ssm_parameter.db_name.value
    secret_key   = data.aws_ssm_parameter.secret_key.value
    rds_endpoint = aws_db_instance.db.endpoint
  })
  filename = "${path.module}/../helm_chart/values.yaml"
}
