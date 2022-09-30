output "output_s3_arn" {
    description = "S3 ARN"
    value = aws_s3_bucket.b.arn
}