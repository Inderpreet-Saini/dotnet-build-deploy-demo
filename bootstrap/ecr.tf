resource "aws_ecr_repository" "ecr" {
  name  = "${lower(var.ecr_namespace)}/${var.ecr_service_name}"
  force_delete = var.ecr_force_delete

  tags = local.common_tags
}

output "ecr_repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}