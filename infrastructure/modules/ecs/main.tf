locals {
  name = "${lower(var.project_name)}-${var.environment}"
}

resource "aws_ecs_cluster" "main" {
  name = "${local.name}-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_iam_policy" "s3_access" {
  name        = "${var.environment}EcsTaskExecutionS3Access"
  description = "ECS Task Executioner can access S3 objects"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "s3:GetObject"
            ],
            Resource = [
                "${var.s3_arn}/.${var.environment}.env"
            ]
        },
        {
            Effect = "Allow"
            Action = [
                "s3:GetBucketLocation"
            ],
            Resource = [
                "${var.s3_arn}",
                "${var.s3_arn}/",
                "${var.s3_arn}/*"
            ]
        }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = data.aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}




resource "aws_ecs_task_definition" "td" {
  family = "${local.name}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  container_definitions = <<TASK_DEFINITION
  [
    {
      "name": "${local.name}-container",
      "cpu": 1024,
      "memory": 2048,
      "image": "${var.ecr_image}",
      "essential": true,
      "environment": [],
      "environmentFiles": [
        {
          "value": "${var.s3_arn}/.${var.environment}.env",
          "type": "s3"
        }
      ],
      "portMappings": [
        {
          "containerPort": ${var.app_port},
          "hostPort": ${var.app_port}
        }
      ]
    }
  ]
  TASK_DEFINITION
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}


resource "aws_security_group" "ecs_service_sg" {
  name = "${local.name}-ecs-service-sg"

  description = "ECS Service security group (terraform-managed)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [var.lb_security_group_id]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "service" {
  name            = "${local.name}-service"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.td.arn
  scheduling_strategy = "REPLICA"
  desired_count   = 1

  network_configuration {
    subnets = [var.subnet_1_id, var.subnet_2_id]
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "${local.name}-container"
    container_port   = var.app_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
