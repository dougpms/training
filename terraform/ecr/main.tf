resource "aws_ecr_repository" "internal_training" {
  name                 = "internal_training_${terraform.workspace}}"
  image_tag_mutability = "MUTABLE"
  force_delete = "true"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {}
}

# Lifecycle policy to delete images in the next day - Budget friendly / Not PRD friendly
resource "aws_ecr_lifecycle_policy" "image_deletion" {
  repository = aws_ecr_repository.internal_training.name
  policy     = <<EOF
  {
   "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 1 day",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v", "latest"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Expire images older than 1 day",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
  }
EOF
}