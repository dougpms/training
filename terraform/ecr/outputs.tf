output "ecr_id" {
  value = aws_ecr_repository.internal_training.id
}

output "ecr_url" {
  value = aws_ecr_repository.internal_training.repository_url
}

output "ecr_arn" {
  value = aws_ecr_repository.internal_training.arn
}