output "ecr_repository_urls" {
  value = { for repo in aws_ecr_repository.main : repo.name => repo.repository_url }
}