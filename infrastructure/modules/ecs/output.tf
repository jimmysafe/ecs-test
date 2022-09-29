output "output_ecs_service_sg_id" {
    description = "Load Balancer Zone ID"
    value = aws_security_group.ecs_service_sg.id
}