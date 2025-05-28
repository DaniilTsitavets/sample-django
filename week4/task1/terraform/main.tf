terraform {
  required_providers {
    aws = {
      region = var.region
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }

  backend "s3" {
    encrypt      = true
    bucket       = "backend-58490149"
    region       = var.region
    key          = "terraform.tfstate"
    use_lockfile = true
  }
  required_version = "~> 1.10"
}