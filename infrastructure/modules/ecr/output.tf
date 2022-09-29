
output "output_ecr_image_url" {
    description = "ECR Image URI"
    value = "${aws_ecr_repository.ecr.repository_url}:latest"
}
