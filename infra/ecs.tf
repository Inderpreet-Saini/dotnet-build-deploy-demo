#########################
## Creates an ECS Cluster
#########################

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.common_prefix}-ecs-cluster"

  tags = local.common_tags
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}