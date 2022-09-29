variable "aws_profile" {
  type        = string
  description = "AWS profile to use"
}

variable "aws_region" {
  type        = string
  description = "AWS region to use"
}

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

variable "app_port" {
  type        = number
  description = "Port on which the dockerized app will run on (EXPOSED PORT NUMBER in Dockerfile)"
}





