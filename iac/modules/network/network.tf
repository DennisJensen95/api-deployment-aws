module "aws_vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.28.1"

  cidr_block = var.cidr_block
}

# Subnets based of of cloudposse
module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.39.8"

  availability_zones   = var.availability_zones
  vpc_id               = module.aws_vpc.vpc_id
  igw_id               = module.aws_vpc.igw_id
  cidr_block           = module.aws_vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 4.0"

  name                = var.security_group_name
  vpc_id              = module.aws_vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name            = var.load_balancer_name
  vpc_id          = module.aws_vpc.vpc_id
  subnets         = module.subnets.public_subnet_ids
  security_groups = [module.security_group.security_group_id]

  target_groups = [
    {
      name             = "novozymes-api"
      backend_port     = 80
      backend_protocol = "HTTP"
      target_type      = "ip"
      vpc_id           = module.aws_vpc.vpc_id
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
  value = module.aws_vpc.vpc_id
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
