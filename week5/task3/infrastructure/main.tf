module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = "10.0.0.0/16"
  azs = ["eu-north-1a", "eu-north-1b"]
  public_subnet_cidr_blocks  = ["10.0.1.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24"]
  isolated_subnet_cidr_blocks = ["10.0.5.0/24", "10.0.6.0/24"]

  region = "eu-north-1"
}

module "s3" {
  source = "./modules/s3"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}