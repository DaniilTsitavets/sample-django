output "ips" {
  value = [aws_instance.k8s-hard-way-ec2-instance[*].public_ip]
}