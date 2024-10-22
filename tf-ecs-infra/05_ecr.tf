resource "aws_ecr_repository" "webapp" {
  name  = "webapp"
}

resource "aws_ecr_repository" "identity" {
  name  = "identity"
}

resource "aws_ecr_repository" "ticketing" {
  name  = "ticketing"
}

resource "aws_ecr_repository" "activity" {
  name  = "activity"
}

resource "aws_ecr_repository" "coding" {
  name  = "coding"
}

resource "aws_ecr_lifecycle_policy" "webapp" {
  repository = aws_ecr_repository.webapp.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 3 images"
        selection    = {
          tagStatus = "tagged"
          tagPrefixList = [local.env_name]
          countType = "imageCountMoreThan"
          countNumber = 30
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images"
        selection    = {
          tagStatus = "untagged"
          countType = "imageCountMoreThan"
          countNumber = 1
        }
        action = { type = "expire" }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "identity" {
  repository = aws_ecr_repository.identity.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 3 images"
        selection    = {
          tagStatus = "tagged"
          tagPrefixList = [local.env_name]
          countType = "imageCountMoreThan"
          countNumber = 30
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images"
        selection    = {
          tagStatus = "untagged"
          countType = "imageCountMoreThan"
          countNumber = 1
        }
        action = { type = "expire" }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "ticketing" {
  repository = aws_ecr_repository.ticketing.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 3 images"
        selection    = {
          tagStatus = "tagged"
          tagPrefixList = [local.env_name]
          countType = "imageCountMoreThan"
          countNumber = 30
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images"
        selection    = {
          tagStatus = "untagged"
          countType = "imageCountMoreThan"
          countNumber = 1
        }
        action = { type = "expire" }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "activity" {
  repository = aws_ecr_repository.activity.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 3 images"
        selection    = {
          tagStatus = "tagged"
          tagPrefixList = [local.env_name]
          countType = "imageCountMoreThan"
          countNumber = 30
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images"
        selection    = {
          tagStatus = "untagged"
          countType = "imageCountMoreThan"
          countNumber = 1
        }
        action = { type = "expire" }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "coding" {
  repository = aws_ecr_repository.coding.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 3 images"
        selection    = {
          tagStatus = "tagged"
          tagPrefixList = [local.env_name]
          countType = "imageCountMoreThan"
          countNumber = 30
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images"
        selection    = {
          tagStatus = "untagged"
          countType = "imageCountMoreThan"
          countNumber = 1
        }
        action = { type = "expire" }
      }
    ]
  })
}