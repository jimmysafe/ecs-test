
output "output_lb_security_group_id" {
    description = "Load Balancer Security group"
    value = aws_security_group.lb_sg.id
}
output "output_lb_target_group_arn" {
    description = "Load Balancer Target Group ARN"
    value = aws_lb_target_group.lb_tg.arn
}
