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

variable "ecs_service_sg_id" {
  type        = string
  description = "ECS Service Security Group ID"
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


