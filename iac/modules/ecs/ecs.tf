resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

module "container_definition" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.58.1"

  container_name  = "novozymes-api"
  container_image = "778701938697.dkr.ecr.eu-north-1.amazonaws.com/novozymes-ecr"
  port_mappings = [
    {
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }
  ]
}

output "container_definition_json" {
  value = module.container_definition.json_map_encoded_list
}

output "aws_ecs_cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}
