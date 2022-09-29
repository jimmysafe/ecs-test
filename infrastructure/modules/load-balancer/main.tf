locals {
  name = "${lower(var.project_name)}-${var.environment}"
}

resource "aws_security_group" "lb_sg" {
  name = "${local.name}-lb-sg"

  description = "LB security group (terraform-managed)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  name               = "${local.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [var.subnet_1_id, var.subnet_2_id]

  tags = {
    Environment = "production"
  }
}


resource "aws_lb_target_group" "lb_tg" {
  name        = "${local.name}-lb-tg-${substr(uuid(), 0, 3)}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_lb_listener" "lb_listener_http" {  
  load_balancer_arn = "${aws_lb.lb.arn}"  
  port              = "80"  
  protocol          = "HTTP"
  
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

resource "aws_lb_listener" "lb_listener_https" {  
  load_balancer_arn = "${aws_lb.lb.arn}"  
  port              = "443"  
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_arn
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.lb_tg.arn}"
    type             = "forward"  
  }
}


