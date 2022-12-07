resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

module "container_definition" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.58.1"

  container_name  = "api-api"
  container_image = "778701938697.dkr.ecr.eu-north-1.amazonaws.com/api-ecr:latest"
  port_mappings = [
    {
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }
  ]
}

module "ecs_alb_service_task" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.66.2"

  namespace                 = "rdx"
  stage                     = "dev"
  name                      = "api-api"
  container_definition_json = module.container_definition.json_map_encoded_list
  ecs_cluster_arn           = aws_ecs_cluster.cluster.arn
  launch_type               = "FARGATE"
  platform_version          = "1.3.0"
  vpc_id                    = var.vpc_id
  security_group_ids        = [var.security_group_id]
  subnet_ids                = var.subnet_ids
  assign_public_ip          = true

  health_check_grace_period_seconds = 60
  ignore_changes_task_definition    = false

  ecs_load_balancers = [
    {
      target_group_arn = var.alb_arn
      elb_name         = ""
      container_name   = "api-api"
      container_port   = 80
  }]
}
