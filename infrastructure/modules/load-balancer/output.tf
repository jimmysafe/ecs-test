
output "output_lb_security_group_id" {
    description = "Load Balancer Security group"
    value = aws_security_group.lb_sg.id
}
output "output_lb_target_group_arn" {
    description = "Load Balancer Target Group ARN"
    value = aws_lb_target_group.lb_tg.arn
}
output "output_lb_dns_name" {
    description = "Load Balancer DNS Name"
    value = aws_lb.lb.dns_name
}
output "output_lb_zone_id" {
    description = "Load Balancer Zone ID"
    value = aws_lb.lb.zone_id
}
