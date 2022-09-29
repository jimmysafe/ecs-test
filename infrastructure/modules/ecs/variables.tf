variable "environment" {
  type        = string
  description = "Staging or production (staging/prod)"
  validation {
    condition     = contains(["production", "staging"], var.environment)
    error_message = "Must be one of 'staging' or 'prod'."
  }
}

variable "project_name" {
  type        = string
  description = "Name of project. e.g. limelight"
}

variable "ecr_image" {
  type        = string
  description = "ECR Docker Image Url"
}

variable "app_port" {
  type        = number
  description = "Port on which the dockerized app will run on (EXPOSED PORT NUMBER in Dockerfile)"
}


variable "lb_security_group_id" {
    type        = string
    description = "Load Balancer Security group"
}
variable "lb_target_group_arn" {
    type        = string
    description = "Load Balancer Target Group ARN"
}

variable "vpc_id" {
  type        = string
  description = "AWS VPC ID"
}

variable "subnet_1_id" {
  type        = string
  description = "AWS Subnet Public/Private ID 1"
}

variable "subnet_2_id" {
  type        = string
  description = "AWS Subnet Public/Private ID 2"
}

