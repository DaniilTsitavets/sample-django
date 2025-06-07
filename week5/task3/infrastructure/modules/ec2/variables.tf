variable "ami" {
  type = string
  default = ""
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "iam_instance_profile_name" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "ec2_sg" {
  type = string
}