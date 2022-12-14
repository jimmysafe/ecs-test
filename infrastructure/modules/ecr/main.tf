
data "aws_caller_identity" "current" {}

locals {
    name = "${lower(var.project_name)}-${var.environment}"
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_ecr_repository" "ecr" {
  name                 = local.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

    provisioner "local-exec" {
        command = <<-EOT
            aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
            docker build -t ${local.name} ../..
            docker tag ${local.name}:latest ${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${local.name}:latest
            docker push ${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${local.name}:latest
        EOT
        interpreter = ["/bin/bash", "-c"]
    }
}

resource "aws_ecr_lifecycle_policy" "expire_policy" {
  repository = aws_ecr_repository.ecr.name

  policy = <<EOF
    {
      "rules": [
        {
          "rulePriority": 1,
          "description": "remove untagged images after 1 day",
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
