locals {
  name = "${lower(var.project_name)}-${var.environment}"
}
resource "aws_s3_bucket" "b" {
  bucket = "${local.name}-bucket"

  tags = {
    Name        = "${local.name}-bucket"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

resource "aws_s3_object" "env" {
  key                    = ".${var.environment}.env"
  bucket                 = aws_s3_bucket.b.id
  content                 = "# .${var.environment}.env"
}