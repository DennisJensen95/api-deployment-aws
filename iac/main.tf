# Require TF version to be same as or greater than 0.12.13
terraform {
  required_version = ">=0.12.13"
  backend "s3" {
    bucket         = "novozymes-interview-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "novozymes-aws-locks"
    encrypt        = true
  }
}

# Download any stable version in AWS provider of 2.36.0 or higher in 2.36 train
provider "aws" {
  region = "eu-north-1"
}

# Call the seed_module to build our ADO seed info
module "bootstrap" {
  source               = "./modules/bootstrap"
  name_of_s3_bucket    = "novozymes-interview-terraform-state"
  dynamo_db_table_name = "novozymes-aws-locks"
}

module "container-registry" {
  source   = "./modules/container-registry"
  ecr_name = "novozymes-ecr"
}

module "network" {
  source              = "./modules/network"
  availability_zones  = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  subnet_name         = "novozymes-subnet"
  load_balancer_name  = "novozymes-lb"
  security_group_name = "novozymes-sg"
}

module "ecs" {
  source           = "./modules/ecs"
  ecs_cluster_name = "novozymes-ecs"
}

module "ecs_alb_service_task" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.55.0"

  namespace                 = "rdx"
  stage                     = "dev"
  name                      = "novozymes-api"
  container_definition_json = module.ecs.container_definition_json
  ecs_cluster_arn           = module.ecs.aws_ecs_cluster_arn
  launch_type               = "FARGATE"
  vpc_id                    = module.network.aws_vpc_id
  security_group_ids        = [module.network.aws_security_group_id]
  subnet_ids                = module.network.aws_subnet_ids

  health_check_grace_period_seconds = 60
  ignore_changes_task_definition    = false

  ecs_load_balancers = [
    {
      target_group_arn = module.network.aws_alb_arn
      elb_name         = ""
      container_name   = "novozymes-api"
      container_port   = 80
  }]
}

