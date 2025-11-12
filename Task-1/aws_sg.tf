module "public_sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "app-tools-sg"
  description = "Security group for App and Tools EC2 instances"
  vpc_id      = module.aws_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow SSH"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTP"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow Jenkins Web Access"
    }
  ]

  egress_rules = ["all-all"]
}
