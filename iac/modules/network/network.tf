
resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.dns_supported
  enable_dns_hostnames = var.dns_host_name
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Subnets based of of cloudposse
module "subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/2.0.4"
  namespace          = "rdx"
  stage              = "dev"
  name               = var.subnet_name
  vpc_id             = aws_vpc.default.id
  igw_id             = [aws_internet_gateway.default.id]
  ipv4_cidr_block    = [aws_vpc.default.cidr_block]
  availability_zones = var.availability_zones
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 4.0"

  name                = var.security_group_name
  vpc_id              = aws_vpc.default.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name            = var.load_balancer_name
  vpc_id          = aws_vpc.default.id
  subnets         = module.subnets.public_subnet_ids
  security_groups = [module.security_group.security_group_id]

  target_groups = [
    {
      name             = "novozymes-api-2"
      backend_port     = 80
      backend_protocol = "HTTP"
      target_type      = "ip"
      vpc_id           = aws_vpc.default.id
      health_check = {
        path    = "/docs"
        port    = "80"
        matcher = "200-399"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

}


output "aws_vpc_id" {
  value = aws_vpc.default.id
}

output "aws_subnet_ids" {
  value = module.subnets.public_subnet_ids
}

output "aws_security_group_id" {
  value = module.security_group.security_group_id
}

output "aws_alb_arn" {
  value = module.alb.target_group_arns[0]
}
