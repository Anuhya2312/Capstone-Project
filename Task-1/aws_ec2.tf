# --- Ubuntu AMI ---
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

# --- Key Pair (optional: replace with your key name if already created) ---
resource "aws_key_pair" "upgrad_key" {
  key_name   = "upgrad-key"
  public_key = file("/home/ubuntu/.ssh/id_rsa.pub")
}

# --- App Machine (Public) ---
module "app_machine" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  name                    = "App-Machine"
  instance_type           = "t3.small"
  ami                     = data.aws_ami.ubuntu.id
  key_name                = aws_key_pair.upgrad_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids   = [module.public_sg.security_group_id]
  subnet_id               = module.aws_vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Role        = "App"
  }
}

# --- Tools Machine (Public) ---
module "tools_machine" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  name                    = "Tools-Machine"
  instance_type           = "t3.small"
  ami                     = data.aws_ami.ubuntu.id
  key_name                = aws_key_pair.upgrad_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids   = [module.public_sg.security_group_id]
  subnet_id               = module.aws_vpc.public_subnets[1]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Role        = "Tools"
  }
}

# --- Outputs ---
output "app_machine_public_ip" {
  value = module.app_machine.public_ip
}

output "tools_machine_public_ip" {
  value = module.tools_machine.public_ip
}

output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "key_pair_name" {
  description = "Name of the EC2 key pair used"
  value       = aws_key_pair.upgrad_key.key_name
}
