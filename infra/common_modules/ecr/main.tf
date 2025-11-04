resource "aws_ecr_repository" "main" {
  count = length(var.ecr_repository_names)
  name  = var.ecr_repository_names[count.index]
}

