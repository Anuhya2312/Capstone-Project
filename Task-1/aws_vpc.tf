module "aws_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "AWS-vpc-upgrad"
  cidr = "10.10.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets  = ["10.10.101.0/24", "10.10.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway  = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway = false

  public_subnet_names  = ["public-subnet-1", "public-subnet-2"]
  private_subnet_names = ["private-subnet-1", "private-subnet-2"]

  tags = {
    Terraform = "true"
    Environment = "dev"
    Cloud       = "AWS"
  }
}

output "aws_vpc_id" {
  value = module.aws_vpc.vpc_id
}
