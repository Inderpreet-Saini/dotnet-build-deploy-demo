########################################################################################################################
## Creates ECS Task Definition
########################################################################################################################

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "${var.common_prefix}-ecs-task-definition"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_iam_role.arn
  cpu                = 256
  memory             = 256
  skip_destroy = true
  container_definitions = jsonencode([
    {
      name         = var.container_name
      image        = "${var.ecr_image_repo}:${var.image_tag}"
      essential    = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]    
    }
  ])

  tags = local.common_tags
}
