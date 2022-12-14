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

variable "domain" {
  type        = string
  description = "Domain of project. e.g. app.example.com or example.com"
}

variable "db_instance_class" {
  type        = string
  description = "Db Instance class e.g t3.micro"
}

variable "db_username" {
  type        = string
  description = "Db username"
}

variable "db_name" {
  type        = string
  description = "Db Name"
}

variable "db_password" {
  type        = string
  description = "Db Name"
}





